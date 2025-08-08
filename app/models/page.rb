class Page < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  def self.find_by_slug(slug)
    find_by(slug: slug)
  end

  private

  def generate_slug
    self.slug = title.parameterize
  end
end
