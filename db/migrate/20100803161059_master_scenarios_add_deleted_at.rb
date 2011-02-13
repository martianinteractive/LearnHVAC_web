class MasterScenariosAddDeletedAt < ActiveRecord::Migration
  def self.up
    add_column :master_scenarios, :deleted_at, :time
  end

  def self.down
    remove_column :master_scenarios, :deleted_at
  end
end
