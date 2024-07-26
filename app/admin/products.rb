ActiveAdmin.register Product do
  permit_params :name, :description, :base_price, :stock_quantity, :category_id, :image

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :base_price
      f.input :stock_quantity
      f.input :category
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :base_price
      row :stock_quantity
      row :category
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), size: "200x200"
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :base_price
    column :stock_quantity
    column :category
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), size: "50x50"
      end
    end
    actions
  end
end
