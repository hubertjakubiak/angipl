class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :good_count, :default => 0
      t.integer :bad_count, :default => 0
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :stats, :user_id
  end
end
