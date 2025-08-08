class Product < ApplicationRecord
  # Associations
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :descrption, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :price, presence: true, numericality: { 
    greater_than: 0, 
    less_than: 10000,
    message: "must be between $0.01 and $9,999.99" 
  }
  validates :stock_quantity, presence: true, numericality: { 
    greater_than_or_equal_to: 0, 
    only_integer: true,
    message: "must be a non-negative integer" 
  }
  validates :image, length: { maximum: 255 }, allow_blank: true

  # Custom validations
  validate :price_has_valid_decimal_places
  validate :name_uniqueness_case_insensitive

  # Scope for filtering
  scope :recently_updated, -> { where('updated_at >= ?', 1.week.ago) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :available, -> { in_stock }

  # Instance methods
  def in_stock?
    stock_quantity > 0
  end

  def formatted_price
    "$#{'%.2f' % price}"
  end

  private

  def price_has_valid_decimal_places
    return unless price.present?
    
    if price.to_s.split('.').last.length > 2
      errors.add(:price, "can have at most 2 decimal places")
    end
  end

  def name_uniqueness_case_insensitive
    return unless name.present?
    
    existing_product = Product.where('LOWER(name) = ?', name.downcase)
    existing_product = existing_product.where.not(id: id) if persisted?
    
    if existing_product.exists?
      errors.add(:name, "has already been taken (case insensitive)")
    end
  end
end
