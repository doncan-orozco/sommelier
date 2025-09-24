class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.string :table_name, null: false
      t.text :notes
      t.string :status, default: 'pending'
      t.decimal :total_amount, precision: 8, scale: 2, default: 0

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
    add_index :orders, :status
    add_index :orders, :created_at
  end
end
