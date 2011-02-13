class ExtraIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :role_code
  end

  def self.down
    remove_index :users, :role_code
  end
end