ActiveAdmin.register_page "About Page" do
  content do
    static_page = StaticPage.find_or_create_by(slug: 'about') do |page|
      page.title = "About Us"
      page.content = "This is the about page content. You can edit this content from the admin dashboard."
    end

    render partial: 'admin/about_page', locals: { static_page: static_page }
  end

  page_action :update, method: :post do
    static_page = StaticPage.find_by(slug: 'about')
    if static_page.update(permitted_params[:static_page])
      redirect_to admin_about_page_path, notice: "About page updated successfully."
    else
      redirect_to admin_about_page_path, alert: "Failed to update about page."
    end
  end

  controller do
    def permitted_params
      params.permit(static_page: [:title, :content])
    end
  end
end
