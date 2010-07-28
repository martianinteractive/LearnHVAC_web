class CreateScenarioVariables < ActiveRecord::Migration
  def self.up
    create_table :scenario_variables do |t|
      t.string :name
      t.string :display_name
      t.text :description
      t.string :unit_si
      t.string :unit_ip
      t.string :si_to_ip
      t.string :left_label
      t.string :right_label
      t.string :subsection
      t.string :zone_position
      t.string :fault_widget_type
      t.text :notes
      t.string :component_code
      t.string :io_type
      t.string :view_type,          :default => "public"
      t.integer :index
      t.integer :lock_version,      :default => 0
      t.integer :node_sequence,     :default => 0
      t.float :low_value,           :default => 0.0
      t.float :high_value,          :default => 0.0
      t.float :initial_value,       :default => 0.0
      t.boolean :is_fault,          :default => false
      t.boolean :is_percentage,     :default => false
      t.boolean :disabled,          :default => false
      t.boolean :fault_is_active,   :default => false
      t.integer :scenario_id 

      t.timestamps
    end
    
    add_index :scenario_variables, :scenario_id
    add_index :scenario_variables, :component_code
    add_index :scenario_variables, :name
    add_index :scenario_variables, :low_value
    add_index :scenario_variables, :high_value
    add_index :scenario_variables, :initial_value
    add_index :scenario_variables, :io_type
    
  end

  def self.down
    remove_index :scenario_variables, :io_type
    remove_index :scenario_variables, :initial_value
    remove_index :scenario_variables, :high_value
    remove_index :scenario_variables, :low_value
    remove_index :scenario_variables, :name
    remove_index :scenario_variables, :component_code
    remove_index :scenario_variables, :scenario_id
    
    drop_table :scenario_variables
  end
end
