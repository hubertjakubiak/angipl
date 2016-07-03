class DropTables < ActiveRecord::Migration
  def change
    drop_table :polish_words
    drop_table :english_words
    drop_table :translations
  end
end
