class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :shipping_address, presence: true

  enum status: {
    pending: 'pending',
    processing: 'processing',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  scope :recent, -> { order(created_at: :desc) }

  def calculate_total
    order_items.sum { |item| item.price * item.quality }
  end

  def total_items
    order_items.sum(:quality)
  end
end
