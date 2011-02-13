class CreateMasterScenarios < ActiveRecord::Migration
  def self.up
    create_table :master_scenarios do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.integer :desktop_id

      t.timestamps
    end
    
    add_index :master_scenarios, :user_id
    add_index :master_scenarios, :desktop_id
  end

  def self.down
    remove_index :master_scenarios, :desktop_id
    remove_index :master_scenarios, :user_id
    drop_table :master_scenarios
  end
end
