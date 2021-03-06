class Invoice < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :item_receives, :join_table => "invoices_item_receives", :class_name => "ItemReceive"

  validates_presence_of :number
  validates_presence_of :user_date

  def validate
    errors.add_to_base('Purchase invoice must have at least 1 item receive') if item_receives.blank?
  end

  def after_initialize
    if new_record?
      self.number = next_available_number
      self.user_date = Time.now.to_date
    end
  end

  def next_available_number
    last_number = company.invoices.last.try(:number)
    next_available = last_number.nil? ? '00001' : sprintf('%05d', last_number.split('.').last.to_i + 1)
    time = Time.now
    prefix = "#{TRANS_PREFIX[:purchase_invoices]}.#{time.strftime('%Y%m')}"
    "#{prefix}.#{next_available}"
  end

  def total_value
    item_receives.collect { |ir| ir.total_po }.sum
  end

  def self.grand_total(company)
    Company.find(company).invoices.collect { |inv| inv.total_value }.sum
  end
end
