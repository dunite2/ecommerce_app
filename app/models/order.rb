class Order < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Validations
  validates :total, presence: true, numericality: { 
    greater_than: 0, 
    less_than: 100000,
    message: "must be between $0.01 and $99,999.99" 
  }
  validates :status, presence: true
  validates :shipping_address, presence: true, length: { 
    minimum: 10, 
    maximum: 500,
    message: "must be between 10 and 500 characters" 
  }

  # Custom validations
  validate :shipping_address_format
  validate :order_has_items
  validate :total_matches_calculated_total, on: :update

  # Enums
  enum status: {
    pending: 'pending',
    processing: 'processing',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }

  # Instance methods
  def calculate_total
    order_items.sum { |item| item.price * item.quality }
  end

  def total_items
    order_items.sum(:quality)
  end

  def formatted_total
    "$#{'%.2f' % total}"
  end

  def can_be_cancelled?
    pending? || processing?
  end

  def formatted_created_at
    created_at.strftime("%B %d, %Y at %I:%M %p")
  end

  private

  def shipping_address_format
    return unless shipping_address.present?
    
    # Basic validation for shipping address format
    unless shipping_address.include?("\n") || shipping_address.length > 20
      errors.add(:shipping_address, "must include complete address with street, city, state, and ZIP code")
    end
    
    # Check for at least one number (for street address)
    unless shipping_address.match?(/\d/)
      errors.add(:shipping_address, "must include a street number")
    end
  end

  def order_has_items
    if order_items.empty?
      errors.add(:base, "Order must have at least one item")
    end
  end

  def total_matches_calculated_total
    return unless total.present? && order_items.any?
    
    calculated_total = calculate_total
    difference = (total - calculated_total).abs
    
    if difference > 0.01  # Allow for small rounding differences
      errors.add(:total, "does not match the sum of order items")
    end
  end
end
