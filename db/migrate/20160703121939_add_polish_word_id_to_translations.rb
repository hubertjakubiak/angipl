class AddPolishWordIdToTranslations < ActiveRecord::Migration
  def change
    add_column :translations, :polishword_id, :integer
  end
end
