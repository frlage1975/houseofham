ActiveAdmin.register_page "Contact Page" do
  content do
    static_page = StaticPage.find_or_create_by(slug: 'contact') do |page|
      page.title = "Contact Us"
      page.content = "This is the contact page content. You can edit this content from the admin dashboard."
    end

    render partial: 'admin/contact_page', locals: { static_page: static_page }
  end

  page_action :update, method: :post do
    static_page = StaticPage.find_by(slug: 'contact')
    if static_page.update(permitted_params[:static_page])
      redirect_to admin_contact_page_path, notice: "Contact page updated successfully."
    else
      redirect_to admin_contact_page_path, alert: "Failed to update contact page."
    end
  end

  controller do
    def permitted_params
      params.permit(static_page: [:title, :content])
    end
  end
end
