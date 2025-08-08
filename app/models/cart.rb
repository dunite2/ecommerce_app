class Cart < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Validations
  validates :user_id, presence: true, uniqueness: true

  # Instance methods
  def total_items
    cart_items.sum(:quantity)
  end

  def total_price
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def empty?
    cart_items.empty?
  end

  def add_product(product, quantity = 1)
    current_item = cart_items.find_by(product: product)
    
    if current_item
      current_item.quantity += quantity
      current_item.save
    else
      cart_items.create(product: product, quantity: quantity)
    end
  end

  def formatted_total_price
    "$#{'%.2f' % total_price}"
  end
end
