class AddGoalToClass < ActiveRecord::Migration
  def self.up
    add_column :groups,:goal,:string
  end

  def self.down
    remove_column :groups,:goal
  end
end
