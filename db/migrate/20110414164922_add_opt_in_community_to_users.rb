class AddOptInCommunityToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :list_directory, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :list_directory
  end
end
