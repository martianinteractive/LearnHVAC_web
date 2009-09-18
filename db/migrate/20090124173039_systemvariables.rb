class Systemvariables < ActiveRecord::Migration
  def self.up
    create_table :systemvariables do |t|
       t.string  :name
       t.integer :institution_id
       t.string  :display_name
       t.integer :component_id
       t.string  :description
       t.string  :typeID
       t.float   :min_value,         :default => 0.0
       t.float   :default_value,     :default => 0.0
       t.float   :max_value,         :default => 0.0
       t.string  :unit_si
       t.string  :unit_ip
       t.string  :si_to_ip
       t.boolean :is_fault,          :default => false
       t.boolean :global_disable,    :default => false
       t.string  :left_label
       t.string  :right_label
       t.string  :subsection
       t.string  :zone_position
       t.boolean :is_percentage,     :default => false
       t.string  :fault_widget_type
       t.text    :notes
       t.integer :lock_version,      :default => 0
       t.integer :node_sequence,     :default => 100
       t.timestamps
     end
    
  end

  def self.down
    drop_table :systemvariables
  end
end
