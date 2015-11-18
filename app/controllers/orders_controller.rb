require 'options'
require 'notifications'

class OrdersController < ApplicationController
  before_action :closed?, only: [:create, :destroy, :update]
  load_and_authorize_resource except: [:create, :index, :last, :new]

  # TODO test
  def create
    # If the cafe is closed there is nothing to do
    return if closed?

    # If the current user is spamming, deny their request
    if current_user.spamming?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: Order::SPAMMING_MESSAGE and return
        }
        format.json {
          render json: { error: Order::SPAMMING_MESSAGE }, succes: false, status: :bad_request and return
        }
      end
    end

    # If the queue is currently full and the user is not a barista, deny their request
    if !current_user.can_order?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: Order::QUEUE_FULL_MESSAGE and return
        }
        format.json {
          render json: { error: Order::QUEUE_FULL_MESSAGE }, succes: false, status: :bad_request and return
        }
      end
    end

    params = create_params
    params[:user_id] = current_user.id
    params[:status] = Options::STATUS[:pending]
    params.each_pair { |key, value| params[key] = nil if (value.empty? rescue false) }

    begin
      @order = Order.create!(params)
    rescue ActiveRecord::RecordInvalid => e
      respond_to do |format|
        alert = '<h2>There was an error while trying to save the Order</h2><ul>'
        e.record.errors.full_messages.each { |error| alert += "<li>#{error}</li>" }
        alert += '</ul>'
        format.html { redirect_to new_order_path, alert: alert and return }
        format.json { render json: { errors: e.record.errors.full_messages }, success: false, status: :bad_request and return }
      end
    end

    Notifications.ios(current_user, ORDER_CREATED_MESSAGE)

    respond_to do |format|
      format.html { redirect_to root_path, notice: ORDER_CREATED_MESSAGE }
      format.json { render success: true, status: :created }
    end
  end

  def destroy
    # TODO implement
  end

  # TODO test when no last order/when not json/when all is good
  def index # JSON only
    respond_to do |format|
      format.json {
        render json: {
          orders: Order.where({user: current_user}).order(created_at: :desc).limit(10)
        }, success: true, status: :ok
      }
    end
  end

  # TODO test when no last order/when not json/when all is good
  def last # JSON only
    respond_to do |format|
      format.json {
        render json: {
          last: current_user.orders.last
        }, success: true, status: :ok
      }
    end
  end

  def new # HTML only
    @title = 'Place Order'
    @order = Order.new

    respond_to do |format|
      format.html
    end
  end

  private

  ORDER_CREATED_MESSAGE = 'Your order is now in the queue'

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

