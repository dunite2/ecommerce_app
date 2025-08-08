class AddFilterFieldsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :on_sale, :boolean, default: false
    add_column :products, :is_new, :boolean, default: false
    add_column :products, :original_price, :decimal, precision: 10, scale: 2
  end
end
