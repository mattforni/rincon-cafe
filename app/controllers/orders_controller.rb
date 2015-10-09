require 'options'

class OrdersController < ApplicationController
  load_and_authorize_resource except: [:index, :last]
  respond_to :json, except: [:index, :edit]

  # TODO test
  def create
    params = create_params
    params[:user_id] = current_user.id
    params[:status] = Options::STATUSES[:pending]
    @order = Order.create!(params)
    render json: { message: 'Order placed' }, success: true, status: :created
  end

  def destroy
  end

  # TODO test
  def edit
  end

  # TODO test
  def last
    @order = Order.last(current_user)
    respond_to do |format|
      format.html
      format.json { render json: @order.as_json, success: true, status: :ok }
    end
  end

  def index
    @orders = Order.where({user: current_user}).order(created_at: :desc).limit(10)
  end

  def show
  end

  def update
  end

  private

  def create_params
    params.require(:order).permit(
      :beverage,
      :decaf,
      :location,
      :milk,
      :notes,
      :shots,
      :temperature
    )
  end
end

