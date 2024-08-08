ActiveAdmin.register Order do
  permit_params :user_id, :total_price, :status, :pst, :gst, :hst, :pst_rate, :gst_rate, :hst_rate

  index do
    selectable_column
    id_column
    column :user
    column :total_price
    column :status
    column :pst
    column :gst
    column :hst
    column :created_at
    column :updated_at
    actions
  end

  filter :user
  filter :total_price
  filter :status, as: :select, collection: ['new', 'paid', 'shipped']
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Order Details' do
      f.input :user, as: :select, collection: User.all.map { |user| [user.name, user.id] }
      f.input :total_price
      f.input :status, as: :select, collection: ['new', 'paid', 'shipped']
      f.input :pst
      f.input :gst
      f.input :hst
      f.input :pst_rate
      f.input :gst_rate
      f.input :hst_rate
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :total_price
      row :status
      row :pst
      row :gst
      row :hst
      row :pst_rate
      row :gst_rate
      row :hst_rate
      row :created_at
      row :updated_at
    end

    panel "Order Products" do
      table_for order.orders_products do
        column :product
        column :quantity
        column :price
        column :created_at
        column :updated_at
      end
    end

    active_admin_comments
  end

  member_action :mark_as_shipped, method: :put do
    order = Order.find(params[:id])
    order.update(status: 'shipped')
    redirect_to admin_order_path(order), notice: "Order ##{order.id} marked as shipped."
  end

  action_item :ship, only: :show do
    link_to 'Mark as Shipped', mark_as_shipped_admin_order_path(order), method: :put if order.status == 'paid'
  end
end
