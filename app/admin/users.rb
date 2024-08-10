ActiveAdmin.register User do
  permit_params :name, :email, :address, :phone_number, :role_id, :province_id

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :address
    column("Role") { |user| user.role.role_name }
    column :province
    actions
  end

  filter :name
  filter :email
  filter :address
  filter :phone_number
  filter :role, as: :select, collection: Role.all.map { |role| [role.role_name, role.id] }
  filter :province

  form do |f|
    f.inputs 'User Details' do
      f.input :name
      f.input :email
      f.input :address
      f.input :phone_number
      f.input :role, as: :select, collection: Role.all.map { |role| [role.role_name, role.id] }
      f.input :province
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :address
      row :phone_number
      row :role do |user|
        user.role.role_name
      end
      row :province
    end

    panel "Orders" do
      table_for user.orders do
        column :id
        column :total_price
        column :status
        column :created_at
        column :updated_at
        actions defaults: false do |order|
          item "View", admin_order_path(order)
          item "Mark as Shipped", mark_as_shipped_admin_order_path(order), method: :put if order.status == 'paid'
        end
      end
    end
  end

  member_action :mark_as_shipped, method: :put do
    order = Order.find(params[:id])
    order.update(status: 'shipped')
    redirect_to admin_user_path(order.user), notice: "Order ##{order.id} marked as shipped."
  end
end
