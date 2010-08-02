class CreateUserScenarios < ActiveRecord::Migration
  def self.up
    create_table :user_scenarios do |t|
      t.integer :user_id
      t.integer :scenario_id

      t.timestamps
    end
    
    add_index :user_scenarios, :user_id
    add_index :user_scenarios, :scenario_id
  end

  def self.down
    remove_index :user_scenarios, :scenario_id
    remove_index :user_scenarios, :user_id

    drop_table :user_scenarios
  end
end
