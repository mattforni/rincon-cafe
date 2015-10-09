class QueueController < ApplicationController
  def index
    @queue = Order.queue
  end
end

