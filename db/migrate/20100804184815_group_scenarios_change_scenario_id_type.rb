class GroupScenariosChangeScenarioIdType < ActiveRecord::Migration
  def self.up
    change_column :group_scenarios, :scenario_id, :integer
  end

  def self.down
    change_column :group_scenarios, :scenario_id, :string
  end
end
