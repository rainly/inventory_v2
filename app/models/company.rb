class Company < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :users
  has_many :categories
  has_many :items
  has_many :suppliers
  has_many :plus
  has_many :warehouses
  has_many :locations
  has_many :begining_balances
  has_many :item_transfers
  has_many :item_ins
  has_many :item_outs
  has_many :transaction_types
  has_many :general_transactions
  has_many :trackers
  has_many :transactions
  has_many :entries
  has_many :assemblies
  has_many :customers
  has_many :price_lists
  has_many :material_requests
  has_many :quotation_requests
  has_many :quotations
  has_many :sales_orders
  has_many :salesmen
  has_many :kusr_ids
  has_many :kusr_rates

  default_scope :order => :created_at

  def next_stock
    available = trackers.available_transaction
    available.blank? ? transactions.inward.first : available
  end

  def default_warehouse
    warehouses.first(:conditions => { :default => true })
  end

  def sorted_categories
    cat = []; categories.roots.each do |root|
      cat << root << root.descendants
    end
    cat.flatten
  end

  def leaf_categories
    categories.reject { |cat| !cat.leaf? }
  end

  def first_transaction_date
    Transaction.first(:conditions => { :company_id => self.id }, :order => 'created_at ASC').created_at
  end

  def stock
    @stock || Stock.new(self)
  end

  def item_movement_report(from, to, category, warehouse, types)
    # assume every par ams has value(s)
    entries = Entry.transaction_created_at_gte(from.to_s(:db)).transaction_created_at_lte(to.to_s(:db)).transaction_type_not('BeginingBalance')
    entries = entries.transaction_origin_id_or_transaction_destination_id_is(warehouse) unless warehouse.blank?
    if category
      cat = Category.find(category)
      entries = cat.leaf? ? entries.item_category_id_is(cat) : entries.item_category_id_in(cat.leaf_ids)
    end
    #all_items = items.ascend_by_name
    rows = []
    entries.each do |entry|
      eid = entry.item.id
      rows[eid] = {} if rows[eid].blank?
      rows[eid][:item] = entry.item if rows[eid][:item].blank?
      rows[eid][:start_balance] = entry.item.on_hand_until(from - 1.day) if rows[eid][:start_balance].blank?
      rows[eid][:end_balance] = entry.item.stock if rows[eid][:end_balance].blank?
      rows[eid][:transactions] = {} if rows[eid][:transactions].blank?
      rows[eid][:transactions][entry.transaction.transaction_type.code] = 0 if rows[eid][:transactions][entry.transaction.transaction_type.code].nil?
      rows[eid][:transactions][entry.transaction.transaction_type.code] = rows[eid][:transactions][entry.transaction.transaction_type.code] + entry.quantity
    end
    rows.compact
  end
end
