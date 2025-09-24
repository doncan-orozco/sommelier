class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :order_items, [:order_id, :menu_item_id], unique: true
  end
end
