class WelcomeController < ApplicationController
  def index
    Rails.logger.warn ">>>> Request url: #{request.protocol}#{request.host}"
  end
end
