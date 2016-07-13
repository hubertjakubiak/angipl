class AddVerifiedToWords < ActiveRecord::Migration
  def change
    add_column :words, :verified, :boolean, :default => false
  end
end
