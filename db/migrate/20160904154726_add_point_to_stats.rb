class AddPointToStats < ActiveRecord::Migration
  def change
    add_column :stats, :points, :integer, :default => 0
  end
end
