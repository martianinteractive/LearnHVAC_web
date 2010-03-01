class Scenarios < ActiveRecord::Migration
  def self.up
    create_table :scenarios do |t|
      t.string   :scenID
      t.integer  :institution_id
      t.integer  :weatherfile_id
      t.string   :name
      t.string   :short_description
      t.text     :description
      t.text     :goal
      t.string   :movie_URL
      t.string   :thumbnail_URL
      t.integer  :level,                          :default => 1
      t.boolean  :inputs_visible,                 :default => true
      t.boolean  :inputs_enabled,                 :default => true
      t.boolean  :faults_visible,                 :default => true
      t.boolean  :faults_enabled,                 :default => true
      t.boolean  :drag_sensor_enabled,            :default => true
      t.boolean  :valve_info_enabled,             :default => true
      t.boolean  :use_custom_output_graphs,       :default => false
      t.integer  :position
      t.integer  :lock_version,                   :default => 0
      t.datetime :longterm_start_date,            :default => '2009-01-01 00:00:00'
      t.datetime :longterm_stop_date,             :default => '2009-12-31 00:00:00'
      t.boolean  :allow_longterm_date_change,     :default => false
      t.datetime :realtime_start_datetime,        :default => '2009-01-01 00:00:00'
      t.boolean  :allow_realtime_datetime_change, :default => false
      t.boolean  :force_long_term_sim,            :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :scenarios
  end
end
