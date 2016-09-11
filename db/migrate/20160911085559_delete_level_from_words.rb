class DeleteLevelFromWords < ActiveRecord::Migration
  def change
    remove_column :words, :level
  end
end
