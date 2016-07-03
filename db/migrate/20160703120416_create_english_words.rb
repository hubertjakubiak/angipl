class CreateEnglishWords < ActiveRecord::Migration
  def change
    create_table :english_words do |t|
      t.string :content

      t.timestamps null: false
    end
  end
end
