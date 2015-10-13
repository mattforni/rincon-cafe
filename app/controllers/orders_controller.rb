require 'options'
require 'notifications'

class OrdersController < ApplicationController
  before_action :closed?, only: [:create, :destroy, :update]
  load_and_authorize_resource except: [:create, :index, :last]

  # TODO test
  def create
    # If the cafe is closed there is nothing to do
    return if closed?

    # If the current user is spamming, deny their request
    if current_user.spamming?
      respond_to do |format|
        format.html {
          flash.alert SPAMMING_MESSAGE
          redirect_to root_path
        }
        format.json {
          render json: { error: SPAMMING_MESSAGE }, succes: false, status: :bad_request and return
        }
      end
    end

    # If the queue is currently full and the user is not a barista, deny their request
    if Order.queue_full? and !current_user.barista
      respond_to do |format|
        format.html {
          flash.alert QUEUE_FULL_MESSAGE
          redirect_to root_path
        }
        format.json {
          render json: { error: QUEUE_FULL_MESSAGE }, succes: false, status: :bad_request and return
        }
      end
    end

    params = create_params
    params[:user_id] = current_user.id
    params[:status] = Options::STATUSES[:pending]
    @order = Order.create!(params)

    Notifications.ios(current_user, 'Your order is now in the queue')

    respond_to do |format|
      format.html {
        # TODO add alert
        redirect_to root_path
      }
      format.json {
        render success: true, status: :created
      }
    end
  end

  def destroy
  end

  def edit
    # TODO implement

    respond_to do |format|
      format.html
      format.json { json_unsupported }
    end
  end

  # TODO test
  def last
    @last = current_user.orders.last
  end

  # TODO test
  def index
    @orders = Order.where({user: current_user}).order(created_at: :desc).limit(10)
  end

  # TODO test
  def show
  end

  def update
    # TODO implement
  end

  private

  SPAMMING_MESSAGE = 'Sorry, only one drink per hour.'
  QUEUE_FULL_MESSAGE = 'Sorry, the queue is currently full. Try agian later.'

  def create_params
    params.require(:order).permit(
      :beverage,
      :decaf,
      :location,
      :milk,
      :notes,
      :shots,
      :temperature,
    )
  end
end

