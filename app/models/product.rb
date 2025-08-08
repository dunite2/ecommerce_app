class Product < ApplicationRecord
  # Scope for filtering
  scope :recently_updated, -> { where('updated_at >= ?', 1.week.ago) }
end
