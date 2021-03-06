require 'cafe'

class CafeController < ApplicationController
  before_action :closed?, only: :queue
  skip_before_action :authenticate_via_token!, only: :closed
  skip_before_action :authenticate_user!, only: :closed

  def closed
    respond_to do |format|
      format.html
    end
  end

  # TODO test
  def queue
    @title = 'Queue'
    @queue = Order.queue
    respond_to do |format|
      format.html {
        render layout: false and return if params[:refresh]
      }
      format.json {
        render json: { queue: @queue }, success: true, status: :ok
      }
    end
  end
end

