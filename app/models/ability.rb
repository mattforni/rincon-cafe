require 'options'

class Ability
  include CanCan::Ability

  def initialize(user)
    # If a user is not logged they have no access
    return if user.nil?

    alias_action :create, :read, :update, :destroy, :to => :crud 

    # Admins can do any CRUD action to any order
    can :crud, Order if user.barista

    # All users can create orders
    can :create, Order

    # Users can read their own orders at any point
    can :read, Order, user_id: user.id

    # Users can destroy or update their own orders if they are still pending
    # There may be further restrictions on these actions, but those are handled in the controller
    can [:destroy, :update], Order, user_id: user.id, status: Options::STATUSES[:pending]
  end
end

