class User < ActiveRecord::Base
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@salesforce.com/i

  has_many :orders, dependent: :destroy

  before_save :handle_token

  def as_json
    { user: { email: self.email, token: self.token } }.to_json
  end

  def reset_token!
    handle_token(true)
    self.save!
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

  private

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

