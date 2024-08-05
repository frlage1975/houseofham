class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.find_by(slug: params[:id])
    if @static_page
      render :show
    else
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
