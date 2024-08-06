class ApplicationController < ActionController::Base
  before_action :set_cart_item_count
  helper_method :current_user, :logged_in?

  private

  def set_cart_item_count
    @cart_item_count = session[:cart]&.values&.sum || 0
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    redirect_to new_session_path unless logged_in?
  end

  helper_method :logged_in?, :current_user
end
