class Scenario
  include Mongoid::Document
  
  field :scenario_id
  field :name
  field :movie_url
  field :thumbnail_url
  field :short_description
  field :description
  field :goal
  field :level,                           :type => Integer, :default => 1
  field :inputs_visible,                  :type => Boolean, :default => true
  field :inputs_enabled,                  :type => Boolean, :default => true
  field :faults_visible,                  :type => Boolean, :default => true
  field :faults_enabled,                  :type => Boolean, :default => true
  field :valve_info_enabled,              :type => Boolean, :default => true
  field :allow_longterm_date_change,      :type => Boolean, :default => false
  field :allow_realtime_datetime_change,  :type => Boolean, :default => false
  field :longterm_start_date,             :type => Date
  field :longterm_stop_date,              :type => Date
  field :realtime_start_datetime,         :type => DateTime  
end
