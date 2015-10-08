class User < ActiveRecord::Base
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@salesforce.com/i

  has_many :orders, dependent: :destroy
end

