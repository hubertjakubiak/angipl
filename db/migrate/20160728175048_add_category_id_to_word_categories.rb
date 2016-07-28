class AddCategoryIdToWordCategories < ActiveRecord::Migration
  def change
    add_column :word_categories, :category_id, :integer
  end
end
