class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :en
      t.string :pl
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :words, :user_id
  end
end
