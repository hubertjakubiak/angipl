class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :hide_show_answers_button, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
