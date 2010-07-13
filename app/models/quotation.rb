class Quotation < ActiveRecord::Base
  has_many :quotation_items
  belongs_to :items
  belongs_to :company
  belongs_to :customer
  validates_presence_of :number
  validates_uniqueness_of :number, :scope => :company_id
  

  def tgl_active
   tgl_berlaku = Chronic.parse(tgl_berlaku)
  end
 # accepts_nested_attributes_for :detail_assemblies, :allow_destroy => true, :reject_if => lambda {|a| a['qty'].blank? }
 # attr_accessor :item_name, :supplier_name

  def self.suggested_number(company)
    last_number = Quotation.last.try(:number)
    next_available = last_number.nil? ? '00001' : sprintf('%05d', last_number.split('.').last.to_i + 1)
    time = Time.now
    prefix = "#{TRANS_PREFIX[:quotation]}.#{time.strftime('%Y%m')}"
    "#{prefix}.#{next_available}"
  end

  def item_name
    @item_name || item.try(:name_with_code)
  end
  
  def item_name_with_code
    item.name_with_code
  end
end