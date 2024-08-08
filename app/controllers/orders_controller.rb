class OrdersController < ApplicationController
  before_action :require_login

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
    @order_items = @order.orders_products.includes(:product)
  end

  private

  def require_login
    unless logged_in?
      redirect_to new_session_path, alert: "You must be logged in to access this page."
    end
  end
end
