class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quality, presence: true, numericality: { 
    greater_than: 0, 
    less_than_or_equal_to: 100,
    only_integer: true,
    message: "must be between 1 and 100" 
  }
  validates :price, presence: true, numericality: { 
    greater_than: 0, 
    less_than: 10000,
    message: "must be between $0.01 and $9,999.99" 
  }

  # Custom validations
  validate :product_is_available
  validate :quantity_does_not_exceed_stock
  validate :price_matches_product_price, on: :create

  # Callbacks
  before_validation :set_price, on: :create

  # Instance methods
  def total_price
    price * quality
  end

  def formatted_price
    "$#{'%.2f' % price}"
  end

  def formatted_total_price
    "$#{'%.2f' % total_price}"
  end

  private

  def set_price
    self.price = product.price if product
  end

  def product_is_available
    return unless product.present?
    
    unless product.in_stock?
      errors.add(:product, "is currently out of stock")
    end
  end

  def quantity_does_not_exceed_stock
    return unless product.present? && quality.present?
    
    if quality > product.stock_quantity
      errors.add(:quality, "cannot exceed available stock (#{product.stock_quantity} available)")
    end
  end

  def price_matches_product_price
    return unless product.present? && price.present?
    
    # Allow for small rounding differences
    price_difference = (price - product.price).abs
    if price_difference > 0.01
      errors.add(:price, "does not match current product price")
    end
  end
end
