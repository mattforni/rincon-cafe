class User < ActiveRecord::Base
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@salesforce.com/i

  has_many :orders, dependent: :destroy

  before_save :handle_token

  def can_order?
    # An elevated user can always place an order
    return true if self.elevated?

    !Order.queue_full?
  end

  def elevated?
    self.barista or self.admin
  end

  def reset_token!
    handle_token(true)
    self.save!
  end

  def spamming?
    # If the user is an admin they cannot be spamming
    return false if self.admin

    # If there is no last order the user cannot be spamming
    last = self.orders.last
    return false if last.nil?

    # Otherwise check to see if the last order was within the past hour
    last.created_at.to_i > 1.hour.ago.to_i
  end

  def token_expired?
    self.token_expiration.nil? or self.token_expiration.utc < Time.now.utc
  end

  def token_valid?(token)
    return true if Devise.secure_compare(token, self.token) and !token_expired?

    # Reset the token if it has expired
    reset_token! if token_expired?
    false
  end

  def visible_attributes
    attrs = self.attributes.reject do |key, _|
      HIDDEN_ATTRIBUTES.include?(key.to_sym)
    end
  end

  private

  HIDDEN_ATTRIBUTES = [
    :confirmation_token,
    :confirmed_at,
    :confirmation_sent_at,
    :created_at,
    :encrypted_password,
    :id,
    :remember_created_at,
    :reset_password_token,
    :reset_password_sent_at,
    :token,
    :token_expiration,
    :udid,
    :unconfirmed_email,
    :updated_at
  ]

  def handle_token(force = false)
    # If the token has never been set or has expired, update it
    if self.token.nil? or self.token_expired? or force
      new_token = ''
      loop do
        new_token = SecureRandom.urlsafe_base64(32).tr('lIO0', 'sxyz')
        break if User.where({token: new_token}).first.nil?
      end
      self.token = new_token
      self.token_expiration = Time.now.utc + 2.weeks
    end
  end
end

