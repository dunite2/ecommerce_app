class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quality, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  before_validation :set_price, on: :create

  def total_price
    price * quality
  end

  private

  def set_price
    self.price = product.price if product
  end
end
