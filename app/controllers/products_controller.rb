class ProductsController < ApplicationController
  def index
    @products = Product.all
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.where(on_sale: true) if params[:on_sale] == "1"
    @products = @products.where('updated_at >= ?', 3.days.ago) if params[:recently_updated] == "1"
    @products = @products.where('name LIKE ? OR description LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @product = Product.find(params[:id])
  end
end
