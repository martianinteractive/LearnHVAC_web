class CreateScenarios < ActiveRecord::Migration
  def self.up
    create_table :scenarios do |t|
      t.string :name
      t.string :short_description
      t.text :description
      t.string :goal
      t.date :longterm_start_date,                :default => Date.today.beginning_of_year
      t.date :longterm_stop_date,                 :default => Date.today.end_of_month
      t.datetime :realtime_start_datetime,        :default => Date.today.beginning_of_year + 14.days
      t.integer :level,                           :default => 1
      t.boolean :public,                          :default => false
      t.boolean :inputs_visible,                  :default => true
      t.boolean :inputs_enabled,                  :default => true
      t.boolean :faults_visible,                  :default => true
      t.boolean :faults_enabled,                  :default => true
      t.boolean :valve_info_enabled,              :default => true
      t.boolean :allow_longterm_date_change,      :default => false
      t.boolean :allow_realtime_datetime_change,  :default => false
      t.boolean :student_debug_access,            :default => false
      
      t.integer :desktop_id
      t.integer :master_scenario_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :scenarios, :desktop_id
    add_index :scenarios, :master_scenario_id
    add_index :scenarios, :user_id
  end

  def self.down
    remove_index :scenarios, :user_id
    remove_index :scenarios, :master_scenario_id
    remove_index :scenarios, :desktop_id
    
    drop_table :scenarios
  end
end
