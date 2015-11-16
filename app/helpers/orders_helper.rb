module OrdersHelper
  def option_display(option)
    option.split('_').each{|word| word.capitalize!}.join(' ') rescue 'N/A'
  end

  def queued_partial(order)
    render partial: 'orders/queued', locals: {order: order}
  end
end

