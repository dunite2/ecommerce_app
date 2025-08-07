class RemoveCategoryIdFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :products, :categories if foreign_key_exists?(:products, :categories)
    remove_column :products, :category_id if column_exists?(:products, :category_id)
  end
end
