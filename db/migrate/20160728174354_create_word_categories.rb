class CreateWordCategories < ActiveRecord::Migration
  def change
    create_table :word_categories do |t|
      t.references :word, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
