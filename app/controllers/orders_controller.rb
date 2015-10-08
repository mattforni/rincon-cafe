class OrdersController < ApplicationController
  before_action :get_order, except: :create
  around_action :json_only

  def create
    @order = Order.create!(order_params)
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

