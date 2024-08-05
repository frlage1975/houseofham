ActiveAdmin.register StaticPage do
  permit_params :title, :content, :slug

  form do |f|
    f.inputs do
      f.input :title
      f.input :content
      f.input :slug
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |static_page|
        static_page.content.html_safe
      end
    end
  end
end
