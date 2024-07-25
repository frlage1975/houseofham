class CreateOrdersProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :orders_products do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :tax, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
