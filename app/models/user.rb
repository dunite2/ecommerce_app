class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :orders, dependent: :destroy

  # Additional validations (Devise already handles email and password validation)
  validates :admin, inclusion: { in: [true, false] }
  
  # Custom validations
  validate :email_domain_allowed, if: :email_changed?

  # Scopes
  scope :admins, -> { where(admin: true) }
  scope :customers, -> { where(admin: false) }

  # Instance methods
  def admin?
    admin == true
  end

  def full_name
    email.split('@').first.humanize
  end

  def recent_orders
    orders.order(created_at: :desc).limit(5)
  end

  private

  def email_domain_allowed
    return unless email.present?
    
    # List of blocked domains (you can customize this)
    blocked_domains = ['tempmail.com', '10minutemail.com', 'guerrillamail.com']
    domain = email.split('@').last.downcase
    
    if blocked_domains.include?(domain)
      errors.add(:email, "domain is not allowed")
    end
  end
end
