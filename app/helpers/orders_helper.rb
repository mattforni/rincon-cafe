module OrdersHelper
  def queued_partial(order)
    render partial: 'orders/queued', locals: {order: order}
  end
end

