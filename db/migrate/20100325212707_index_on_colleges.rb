class IndexOnColleges < ActiveRecord::Migration
  def self.up
    add_index :colleges, :value
    add_index :institutions, :name
  end

  def self.down
    remove_index :colleges, :value
    remove_index :institutions, :name
  end
end
