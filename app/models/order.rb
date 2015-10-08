require 'options'

include Options

class Order < ActiveRecord::Base
  # Required attribute validations
  validates :beverage, presence: true, inclusion: {in: BEVERAGE}
  validates :location, presence: true, inclusion: {in: LOCATION}
  validates :temperature, presence: true, inclusion: {in: TEMPERATURE}
  validates :user, presence: true

  # Optional attribute validations
  validates :created_at, uniqueness: {scope: :user_id}
  validates :decaf, inclusion: {in: DECAF}
  validates :milk, inclusion: {in: MILK}
  validates :shots, numericality: {allow_blank: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 2, only_integer: true}

  # Associations
  belongs_to :user
end

