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

  # TODO test
  def self.queue
    Order.where({status: STATUSES[:pending]}).order(created_at: :desc)
  end

  # TODO test
  def self.queue_full?
    self.queue.size >= MAX_QUEUE_SIZE
  end

  def ordered_by
    user.email
  end

  def pending?
    self.status == STATUSES[:pending]
  end

  def queue_position
    # If the status is not pending, there is no queue position
    return unless self.pending?

    Order.queue.each_with_index do |item, index|
      return (index + 1) if item.id == self.id
    end
  end

  def visible_attributes
    attrs = self.attributes.reject do |key, _|
      HIDDEN_ATTRIBUTES.include?(key.to_sym)
    end
    attrs[:ordered_by] = self.ordered_by
    attrs[:queue_position] = self.queue_position if self.pending?
    attrs
  end

  private

  HIDDEN_ATTRIBUTES = [:id, :updated_at, :user_id]
  MAX_QUEUE_SIZE = 15
end

