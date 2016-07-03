class CreatePolishWords < ActiveRecord::Migration
  def change
    create_table :polish_words do |t|
      t.string :content

      t.timestamps null: false
    end
  end
end
