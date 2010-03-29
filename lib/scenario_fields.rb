module ScenarioFields  
  def self.included(parent)
    parent.field :name
    parent.field :movie_url
    parent.field :thumbnail_url
    parent.field :short_description
    parent.field :description
    parent.field :master_scenario_name
    parent.field :master_scenario_version
    parent.field :goal
    parent.field :level,                           :type => Integer, :default => 1
    parent.field :inputs_visible,                  :type => Boolean, :default => true
    parent.field :inputs_enabled,                  :type => Boolean, :default => true
    parent.field :faults_visible,                  :type => Boolean, :default => true
    parent.field :faults_enabled,                  :type => Boolean, :default => true
    parent.field :valve_info_enabled,              :type => Boolean, :default => true
    parent.field :allow_longterm_date_change,      :type => Boolean, :default => false
    parent.field :allow_realtime_datetime_change,  :type => Boolean, :default => false
    parent.field :longterm_start_date,             :type => Date
    parent.field :longterm_stop_date,              :type => Date
    parent.field :realtime_start_datetime,         :type => DateTime
  end  
end
