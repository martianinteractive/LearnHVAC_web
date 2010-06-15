class ScenarioAlert
  include Mongoid::Document
  include Mongoid::Timestamps
    
  field :master_scenario_version
  field :description
  field :read, :type => Boolean, :default => 0
  
  embedded_in :scenario, :inverse_of => :scenario_alerts
end