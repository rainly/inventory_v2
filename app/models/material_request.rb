class MaterialRequest < ActiveRecord::Base
  attr_accessible :company_id, :number, :userdate, :reference, :requester, :description, :entries_attributes
  belongs_to :company
  has_many :entries, :class_name => "MaterialRequestEntry"
  has_and_belongs_to_many :purchase_orders

  validates_presence_of :number, :userdate, :reference, :requester
  validates_uniqueness_of :number, :scope => :company_id

  accepts_nested_attributes_for :entries,
    :allow_destroy => true,
    :reject_if => lambda { |att| att['item_id'].blank? || att['quantity'].blank? }

  #before_save :parse_userdate

  def after_initialize
    if new_record?
      self.number = suggested_number
      self.userdate = Time.now.strftime("%m/%d/%Y") if userdate.blank?
      self.closed = false
    end
  end

  def suggested_number
    last_number = company.material_requests.last.try(:number)
    next_available = last_number.nil? ? '00001' : sprintf('%05d', last_number.split('.').last.to_i + 1)
    time = Time.now
    prefix = "#{TRANS_PREFIX[:material_request]}.#{time.strftime('%Y%m')}"
    "#{prefix}.#{next_available}"
  end

  def name
    number
  end

  def quantity_left_for(item)
    if closed
      0
    else
      entries.find_by_item_id(item).quantity - PoMrTracker.material_request_id_is(id).item_id_is(item).sum(:quantity)
    end
  end

  # mark this MR as closed if all of the entries quantity left is zero (spent on PO)
  def close
    quantity_left = entries.collect { |ent| quantity_left_for(ent.item_id) }.sum
    if quantity_left.zero?
      self.closed = true
      save
    end
  end

  def parse_userdate
    self.userdate = Chronic.parse(userdate)
  end

end
