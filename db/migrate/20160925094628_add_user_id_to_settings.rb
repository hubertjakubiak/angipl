class AddUserIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :user, :refrences
  end
end
