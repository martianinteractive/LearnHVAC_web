class UserScenariosDrop < ActiveRecord::Migration
  def self.up
    drop_table :user_scenarios
  end

  def self.down
    create_table "user_scenarios", :force => true do |t|
      t.integer  "user_id"
      t.integer  "scenario_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
