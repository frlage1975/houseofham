ActiveAdmin.register Tax do
  permit_params :province_id, :gst_rate, :pst_rate, :hst_rate

  # Customizing the index page
  index do
    selectable_column
    id_column
    column :province
    column :gst_rate
    column :pst_rate
    column :hst_rate
    actions
  end

  # Customizing the form
  form do |f|
    f.inputs 'Tax Details' do
      f.input :province, as: :select, collection: Province.all.collect { |province| [province.name, province.id] }
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate
    end
    f.actions
  end

  # Customizing the show page
  show do
    attributes_table do
      row :province
      row :gst_rate
      row :pst_rate
      row :hst_rate
    end
  end
end
