class IndexOnColleges < ActiveRecord::Migration
  def self.up
    add_index :colleges, :value
  end

  def self.down
  end
end
