class CheckoutController < ApplicationController
  before_action :require_login

  def create
    @cart_items = session[:cart]&.map { |product_id, quantity| [Product.find(product_id), quantity] }.to_h
    @user = current_user

    if @cart_items.empty?
      redirect_to shopping_cart_show_path, alert: "Your cart is empty."
      return
    end

    tax = @user.province.taxes.first
    session[:pst_rate] = tax&.pst_rate || 0
    session[:gst_rate] = tax&.gst_rate || 0
    session[:hst_rate] = tax&.hst_rate || 0

    session[:subtotal] = @cart_items.sum { |product, quantity| product.base_price * quantity }
    session[:pst] = session[:subtotal] * session[:pst_rate]
    session[:gst] = session[:subtotal] * session[:gst_rate]
    session[:hst] = session[:subtotal] * session[:hst_rate]
    session[:total] = session[:subtotal] + session[:pst] + session[:gst] + session[:hst]

    @amount = (session[:total] * 100).to_i # Amount in cents

    if params[:stripeToken]
      customer = Stripe::Customer.create(
        email: @user.email,
        source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: @amount,
        description: 'Rails Stripe customer',
        currency: 'usd'
      )

      if charge.paid
        # Handle successful payment here
        redirect_to invoice_path, notice: 'Payment successful!'
      else
        redirect_to invoice_path, alert: 'Payment failed.'
      end
    else
      redirect_to invoice_path, alert: 'Payment could not be processed.'
    end
  end

  def show
    @cart_items = session[:cart]&.map { |product_id, quantity| [Product.find(product_id), quantity] }.to_h
    @user = current_user

    @pst_rate = session[:pst_rate]
    @gst_rate = session[:gst_rate]
    @hst_rate = session[:hst_rate]

    @pst_rate_100 = (session[:pst_rate].to_f * 100).to_i
    @gst_rate_100 = (session[:gst_rate].to_f * 100).to_i
    @hst_rate_100 = (session[:hst_rate].to_f * 100).to_i

    @subtotal = session[:subtotal]
    @pst = session[:pst]
    @gst = session[:gst]
    @hst = session[:hst]
    @total = session[:total]

    render 'invoice'
  end

  private

  def require_login
    unless logged_in?
      redirect_to new_session_path, alert: "You must be logged in to access this page."
    end
  end
end
