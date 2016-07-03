class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :englishword_id
      t.integer :polishword

      t.timestamps null: false
    end
  end
end
