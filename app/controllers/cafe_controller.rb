require 'cafe'

class CafeController < ApplicationController
  before_action :closed?, only: :queue
  respond_to :json, only: :queue
  skip_before_action :authenticate_via_token!, only: :closed
  skip_before_action :authenticate_user!, only: :closed

  def closed
  end

  # TODO test
  def queue
    @queue = Order.queue
    respond_to do |format|
      format.html
      format.json {
        render json: { queue: @queue }, success: true, status: :ok
      }
    end
  end
end

