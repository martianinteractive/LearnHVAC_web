class CreateGroupScenarios < ActiveRecord::Migration
  def self.up
    create_table :group_scenarios do |t|
      t.integer :group_id
      t.string :scenario_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_scenarios
  end
end
