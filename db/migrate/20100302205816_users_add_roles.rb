class UsersAddRoles < ActiveRecord::Migration
  def self.up
    add_column :users, :role_code, :integer, :default => 0
  end

  def self.down
    remove_column :users, :role_code
  end
end
