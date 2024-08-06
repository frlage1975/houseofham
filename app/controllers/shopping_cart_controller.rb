class ShoppingCartController < ApplicationController
  before_action :initialize_cart

  # def add
  #   product_id = params[:product_id].to_s
  #   @cart[product_id] ||= 0
  #   @cart[product_id] += 1
  #   save_cart

  #   redirect_to products_path(filter_params), notice: 'Product added to cart.'
  # end

  def add
    product_id = params[:product_id].to_s
    session[:cart] ||= {}
    session[:cart][product_id] = (session[:cart][product_id] || 0) + 1
    redirect_to product_path(product_id), notice: 'Product added to cart!'
  end

  def remove
    product_id = params[:product_id].to_s
    @cart.delete(product_id)
    save_cart
    redirect_to shopping_cart_show_path, notice: 'Product removed from cart.'
  end

  def show
    @cart_products = Product.find(@cart.keys)
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    @cart[product_id] = quantity
    save_cart
    render json: { success: true }
  end

  private

  def initialize_cart
    @cart = session[:cart] || {}
  end

  def save_cart
    session[:cart] = @cart
  end

  def filter_params
    params.permit(:category_id, :on_sale, :recently_updated, :search)
  end
end
