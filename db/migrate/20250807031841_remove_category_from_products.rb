class RemoveCategoryFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :products, :categories
    remove_column :products, :category_id, :integer
  end
end
