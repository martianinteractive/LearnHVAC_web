module ScenarioFields
  def self.included(parent)
    parent.field :name
    parent.field :short_description
    parent.field :description
    parent.field :goal
    parent.field :longterm_start_date
    parent.field :longterm_stop_date
    parent.field :realtime_start_datetime
    parent.field :level,                           :type => Integer, :default => 1
    parent.field :inputs_visible,                  :type => Boolean, :default => true
    parent.field :inputs_enabled,                  :type => Boolean, :default => true
    parent.field :faults_visible,                  :type => Boolean, :default => true
    parent.field :faults_enabled,                  :type => Boolean, :default => true
    parent.field :valve_info_enabled,              :type => Boolean, :default => true
    parent.field :allow_longterm_date_change,      :type => Boolean, :default => false
    parent.field :allow_realtime_datetime_change,  :type => Boolean, :default => false
  end  
end
