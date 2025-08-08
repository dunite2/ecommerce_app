class Product < ApplicationRecord
  # Scopes for filtering
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :recently_updated, -> { where('updated_at >= ?', 1.week.ago) }

  # Method to check if product has a discount
  def discount_percentage
    return 0 unless on_sale? && original_price.present? && original_price > price
    ((original_price - price) / original_price * 100).round
  end

  def display_price
    on_sale? && original_price.present? ? original_price : price
  end
end
