class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 8, scale: 2, null: false
      t.boolean :available, default: true
      t.integer :sort_order, default: 0

      t.timestamps
    end

    add_index :menu_items, :name, unique: true
    add_index :menu_items, [ :category_id, :sort_order ]
    add_index :menu_items, :available
  end
end
