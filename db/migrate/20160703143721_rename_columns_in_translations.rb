class RenameColumnsInTranslations < ActiveRecord::Migration
  def change
    rename_column :translations, :polishword_id, :polish_word_id
    rename_column :translations, :englishword_id, :english_word_id
  end
end
