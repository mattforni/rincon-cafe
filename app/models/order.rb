require 'options'

include Coffee::Options

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

  # Constants
  SPAMMING_MESSAGE = 'Sorry, only one drink per hour.'
  QUEUE_FULL_MESSAGE = 'Sorry, the queue is currently full. Try agian later.'

  # TODO test
  def self.queue
    Order.where('status IN (?)', QUEUE_STATUSES).order(created_at: :asc)
  end

  # TODO test
  def self.queue_full?
    self.queue.size >= MAX_QUEUE_SIZE
  end

  def owned_by?(user)
    self.user_id == user.id
  end

  def get_actions(user)
    # Only orders in one of the queued statuses have actions
    return [] if QUEUE_STATUSES.include? self.status

    # If the user is not elevated and did not make the order there are no actions
    return [] if user.nil? or !(user.elevated? or self.owned_by?(user))

    # If this order is owned by the current user
    if self.owned_by? user
      # If the order is still pending the user may cancel it
      if self.status == Coffee::Options::STATUS[:pending]
        actions = [Action.new(:cancel, self)] 
        actions << Action.new(:begin, self) if user.elevated?
        return actions
      end
    end

    if user.elevated?
      case self.status.to_sym
      when :pending
        return [Action.new(:begin, self)]
      when :in_progress
        return [Action.new(:finish, self)]
      when :made
        return [
          Action.new(:abandon, self),
          Action.new(:retrieve, self)
        ]
      end
    end

    []
  end

  def in_queue?
    QUEUE_STATUSES.include?(self.status.to_sym)
  end

  def ordered_by
    return user.name if !(user.name.nil? or user.name.empty?)
    user.email.gsub('@salesforce.com', '')
  end

  def queue_position
    # If the order is not in the queue there is no position
    return unless self.in_queue?

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
  QUEUE_STATUSES = [:pending, :in_progress, :made]

  class Action
    attr_accessor :html_options, :order_id

    def initialize(name, order)
      self.name = name
      self.order = order

      self.html_options = get_html_options
      self.order_id = order.id
    end

    private

    attr_accessor :order, :name

    def get_confirmation
      case name.to_sym
      when :abandon
        return 'Are you sure you want to abandon this drink?'
      when :cancel
        return 'Are you sure you want to cancel this drink?' 
      end

      nil
    end

    def get_end_status
      case name.to_sym
      when :abandon
        return STATUS[:abandonded]
      when :begin
        return STATUS[:in_progress]
      when :cancel
        return STATUS[:cancelled]
      when :finish
        return STATUS[:made]
      when :retrieve
        return STATUS[:retrieved]
      end

      nil
    end

    def get_html_options
      clazz = "icon-button #{name}-icon"
      options = {
        class: clazz,
        form_class: clazz,
        method: :put,
        params: {
          status: get_end_status
        }
      }
      confirmation = get_confirmation
      options[:data] = { confirm: confirmation } if !confirmation.nil?
      options
    end
  end
end

