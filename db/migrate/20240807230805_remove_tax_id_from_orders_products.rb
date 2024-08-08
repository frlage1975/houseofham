class RemoveTaxIdFromOrdersProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders_products, :tax_id, :integer
  end
end
