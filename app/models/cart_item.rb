class CartItem < ApplicationRecord
  # Associations
  belongs_to :cart
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { 
    greater_than: 0, 
    less_than_or_equal_to: 100,
    only_integer: true,
    message: "must be between 1 and 100" 
  }
  validates :product_id, uniqueness: { 
    scope: :cart_id, 
    message: "is already in the cart" 
  }

  # Custom validations
  validate :product_is_available
  validate :quantity_does_not_exceed_stock

  # Instance methods
  def total_price
    product.price * quantity
  end

  def formatted_total_price
    "$#{'%.2f' % total_price}"
  end

  def increase_quantity(amount = 1)
    self.quantity += amount
    save
  end

  def decrease_quantity(amount = 1)
    if quantity > amount
      self.quantity -= amount
      save
    else
      destroy
    end
  end

  private

  def product_is_available
    return unless product.present?
    
    unless product.in_stock?
      errors.add(:product, "is currently out of stock")
    end
  end

  def quantity_does_not_exceed_stock
    return unless product.present? && quantity.present?
    
    if quantity > product.stock_quantity
      errors.add(:quantity, "cannot exceed available stock (#{product.stock_quantity} available)")
    end
  end
end
