class ApplicationController < ActionController::Base
  before_action :set_cart_item_count

  private

  def set_cart_item_count
    @cart_item_count = session[:cart]&.values&.sum || 0
  end
end
