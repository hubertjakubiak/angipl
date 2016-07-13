class AddGoodAndBadCountForWords < ActiveRecord::Migration
  def change
    add_column :words, :good_count, :integer, :default => 0
    add_column :words, :bad_count, :integer, :default => 0
  end
end
