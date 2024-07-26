ActiveAdmin.register Product do
  permit_params :name, :description, :base_price, :stock_quantity, :category_id, :image, :on_sale

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :base_price
      f.input :stock_quantity
      f.input :category
      f.input :image, as: :file
      f.input :on_sale, as: :boolean
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :base_price
    column :stock_quantity
    column :category
    column :on_sale
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), size: "50x50"
      end
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :base_price
      row :stock_quantity
      row :category
      row :on_sale
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), size: "200x200"
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  filter :name
  filter :description
  filter :base_price
  filter :stock_quantity
  filter :category
  filter :on_sale
end
