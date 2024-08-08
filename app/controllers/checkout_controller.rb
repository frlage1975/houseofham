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
      begin
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
          save_order('paid')
          session[:cart] = {} # Clear the cart
          redirect_to orders_path, notice: 'Payment successful!'
        else
          redirect_to invoice_path, alert: 'Payment failed.'
        end
      rescue Stripe::CardError => e
        # The card has been declined or other card-related errors
        redirect_to invoice_path, alert: e.message
      rescue Stripe::InvalidRequestError => e
        # Invalid parameters were supplied to Stripe's API
        redirect_to invoice_path, alert: e.message
      rescue Stripe::AuthenticationError => e
        # Authentication with Stripe's API failed
        redirect_to invoice_path, alert: e.message
      rescue Stripe::APIConnectionError => e
        # Network communication with Stripe failed
        redirect_to invoice_path, alert: e.message
      rescue Stripe::StripeError => e
        # Display a generic error message to the user
        redirect_to invoice_path, alert: "Something went wrong with your payment. Please try again."
      rescue StandardError => e
        # Something else happened, completely unrelated to Stripe
        redirect_to invoice_path, alert: e.message
      end
    else
      redirect_to invoice_path
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

    # @order = Order.new
    @order = Order.find(session[:order_id]) if session[:order_id]

    render 'invoice'
  end

  def buy_later
    @cart_items = session[:cart]&.map { |product_id, quantity| [Product.find(product_id), quantity] }.to_h
    @user = current_user

    if @cart_items.empty?
      redirect_to shopping_cart_show_path, alert: "Your cart is empty."
      return
    end

    save_order('new')
    session[:cart] = {} # Clear the cart
    redirect_to orders_path, notice: 'Order saved for later!'
  end

  def pay_now
    @order = Order.find(params[:id])
    @user = current_user

    @pst_rate = @order.pst_rate
    @gst_rate = @order.gst_rate
    @hst_rate = @order.hst_rate

    @pst_rate_100 = (@order.pst_rate.to_f * 100).to_i
    @gst_rate_100 = (@order.gst_rate.to_f * 100).to_i
    @hst_rate_100 = (@order.hst_rate.to_f * 100).to_i

    @subtotal = @order.total_price - @order.pst - @order.gst - @order.hst
    @pst = @order.pst
    @gst = @order.gst
    @hst = @order.hst
    @total = @order.total_price

    render 'paynow'
  end

  def create_payment
    @order = Order.find(params[:id])
    @user = current_user

    @amount = (@order.total_price * 100).to_i # Amount in cents

    if params[:stripeToken]
      begin
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
          # Update the existing order status to paid
          @order.update(status: 'paid')
          #session[:cart] = {} # Clear the cart
          redirect_to orders_path, notice: 'Payment successful!'
        else
          redirect_to pay_now_checkout_path(@order), alert: 'Payment failed.'
        end
      rescue Stripe::CardError => e
        # The card has been declined or other card-related errors
        redirect_to pay_now_checkout_path(@order), alert: e.message
      rescue Stripe::InvalidRequestError => e
        # Invalid parameters were supplied to Stripe's API
        redirect_to pay_now_checkout_path(@order), alert: e.message
      rescue Stripe::AuthenticationError => e
        # Authentication with Stripe's API failed
        redirect_to pay_now_checkout_path(@order), alert: e.message
      rescue Stripe::APIConnectionError => e
        # Network communication with Stripe failed
        redirect_to pay_now_checkout_path(@order), alert: e.message
      rescue Stripe::StripeError => e
        # Display a generic error message to the user
        redirect_to pay_now_checkout_path(@order), alert: "Something went wrong with your payment. Please try again."
      rescue StandardError => e
        # Something else happened, completely unrelated to Stripe
        redirect_to pay_now_checkout_path(@order), alert: e.message
      end
    else
      redirect_to pay_now_checkout_path(@order), alert: e.message
    end
  end

  private

  def save_order(status)
    order = Order.create(
      user: @user,
      total_price: session[:total],
      status: status,
      pst: session[:pst],
      gst: session[:gst],
      hst: session[:hst],
      pst_rate: session[:pst_rate],
      gst_rate: session[:gst_rate],
      hst_rate: session[:hst_rate]
    )

    puts "Order created: #{order.inspect}"

    @cart_items.each do |product, quantity|
      order_product = OrdersProduct.create(
        order: order,
        product: product,
        quantity: quantity,
        price: product.base_price
      )

      puts "Order Product created: #{order_product.inspect}"
    end
  end


  def require_login
    unless logged_in?
      redirect_to new_session_path, alert: "You must be logged in to access this page."
    end
  end
end
