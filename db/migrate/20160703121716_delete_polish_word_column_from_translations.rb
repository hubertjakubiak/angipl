class DeletePolishWordColumnFromTranslations < ActiveRecord::Migration
  def change
    remove_column :translations, :polishword
  end
end
