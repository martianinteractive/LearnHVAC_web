class ScenarioSystemvariables < ActiveRecord::Migration
  def self.up
    create_table :scenario_systemvariables do |t|
      t.integer :scenario_id
      t.integer :systemvariable_id
      t.integer :institution_id
      t.string  :applicationID,     :default => "PUBLIC"
      t.boolean :disabled,          :default => false
      t.float   :low_value,         :default => 0.0
      t.float   :initial_value,     :default => 0.0
      t.float   :high_value,        :default => 0.0
    end
  end

  def self.down
    drop_table :scenario_systemvariables
  end
end
