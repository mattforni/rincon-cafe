module ApplicationHelper
  def asset_exists?(filename, extension)
    return false if filename.nil? or filename.empty? or extension.nil? or extension.empty?
    !RinconCoffee::Application.assets.find_asset("#{filename}.#{extension}").nil?
  end

  def logout_button
    button_to ' ', destroy_user_session_path, data: {confirm: 'Logout for real?'}, method: :delete, class: 'logout', form_class: 'logout'
  end

  def order_partial(order)
    render partial: 'orders/order', locals: {order: order}
  end
end

