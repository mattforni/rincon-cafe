module ApplicationHelper
  def order_partial(order)
    render partial: 'orders/order', locals: {order: order}
  end
end
