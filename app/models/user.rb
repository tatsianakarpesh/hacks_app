class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  validates :first_name, length: { maximum: 50 }, allow_blank: true
  validates :last_name, length: { maximum: 50 }, allow_blank: true
  validates :phone_number,
            format: { with: /\A\+?[\d\s-]+\z/, message: "format is invalid" },
            allow_blank: true

  # Avatar validations
  validate :validate_avatar, if: -> { avatar.attached? }

  def validate_avatar
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/png image/jpg])
      errors.add(:avatar, 'must be a JPEG, JPG or PNG')
    end

    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, 'size must be less than 5MB')
    end
  end

  def avatar_display
    if avatar.attached?
      avatar
    else
      nil # Return nil to indicate we should use the emoji fallback
    end
  end

  def avatar_fallback_class
    "avatar-emoji-fallback bg-primary text-white"
  end

  def avatar_fallback_content
    "👤" # Default user emoji
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  # Check if user has a custom avatar
  def has_custom_avatar?
    persisted? && avatar.attached?
  end
end
