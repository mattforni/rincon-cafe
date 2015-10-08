class OrdersController < ApplicationController
  before_action :get_order, except: :create
  respond_to :json

  def create
    params = order_params
    params[:user_id] = current_user.id
    @order = Order.create!(params)
    render json: { message: 'Order placed' }, success: true, status: :created
  end

  def destroy
  end

  def show
  end

  def update
  end

  private

  def get_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :beverage,
      :decaf,
      :location,
      :milk,
      :notes,
      :shots,
      :status,
      :temperature,
    )
  end
end

