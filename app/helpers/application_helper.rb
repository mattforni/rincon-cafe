require 'options'

module ApplicationHelper
  def asset_exists?(filename, extension)
    return false if filename.nil? or filename.empty? or extension.nil? or extension.empty?
    !Rails.application.assets.find_asset("#{filename}.#{extension}").nil?
  end

  def logout_button
    button_to ' ', destroy_user_session_path, data: {confirm: 'Logout for real?'}, method: :delete, class: 'logout', form_class: 'logout'
  end

  def option_display(option)
    Coffee::Options::display(option)
  end

  def order_partial(order)
    render partial: 'orders/order', locals: {order: order}
  end

  def handle_toast
    message = alert || notice || devise_error_messages! rescue nil
    return if message.nil? || message.empty?
    error = !(alert || devise_error_messages!).nil? rescue false
    render partial: 'application/toast', locals: {message: message, error: error}
  end

  def include(extension)
    # Only support css and js at the moment
    return if !['css', 'js'].include?(extension)

    action = params[:action]
    controller = params[:controller]
    page = File.join(controller, action)
    controller_parts = controller.split('/')

    # Start at the most specific
    file = asset_exists?(page, extension) ? page : nil

    # And start working toward less specific
    file = controller if file.nil? and asset_exists? controller, extension

    if file.nil?
      # Then iterate through all portions of the controller
      (1..controller_parts.length).each do |index|
        controller_path = controller_parts.slice(0, index).join('/')

        # If the asset exists stop searching
        if asset_exists? controller_path, extension
          file = controller_path
          break
        end
      end
    end

    # Fallback to the application if nothing was found
    file = 'application' if file.nil? and asset_exists? 'application', extension

    if extension == 'css'
      stylesheet_link_tag file, media: 'all', 'data-turbolinks-track' => true if !file.nil?
    elsif extension == 'js'
      javascript_include_tag file, 'data-turbolinks-track' => true if !file.nil?
    end
  end
end

