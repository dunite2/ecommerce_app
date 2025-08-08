class Page < ApplicationRecord
  # Validations
  validates :title, presence: true, length: { 
    minimum: 2, 
    maximum: 100,
    message: "must be between 2 and 100 characters" 
  }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }, length: { 
    minimum: 2, 
    maximum: 100 
  }
  validates :content, presence: true, length: { 
    minimum: 10, 
    maximum: 10000,
    message: "must be between 10 and 10,000 characters" 
  }

  # Custom validations
  validate :slug_format
  validate :title_uniqueness_case_insensitive

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  before_validation :clean_slug

  # Scopes
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }

  # Class methods
  def self.find_by_slug(slug)
    find_by(slug: slug.downcase)
  end

  # Instance methods
  def published?
    published == true
  end

  def to_param
    slug
  end

  def word_count
    content.split.length
  end

  private

  def generate_slug
    self.slug = title.parameterize
  end

  def clean_slug
    return unless slug.present?
    self.slug = slug.downcase.strip
  end

  def slug_format
    return unless slug.present?
    
    unless slug.match?(/\A[a-z0-9-]+\z/)
      errors.add(:slug, "can only contain lowercase letters, numbers, and hyphens")
    end
    
    if slug.starts_with?('-') || slug.ends_with?('-')
      errors.add(:slug, "cannot start or end with a hyphen")
    end
    
    if slug.include?('--')
      errors.add(:slug, "cannot contain consecutive hyphens")
    end
  end

  def title_uniqueness_case_insensitive
    return unless title.present?
    
    existing_page = Page.where('LOWER(title) = ?', title.downcase)
    existing_page = existing_page.where.not(id: id) if persisted?
    
    if existing_page.exists?
      errors.add(:title, "has already been taken (case insensitive)")
    end
  end
end
