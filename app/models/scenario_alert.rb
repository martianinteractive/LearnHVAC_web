class ScenarioAlert
  include Mongoid::Document
  include Mongoid::Timestamps
    
  field :description
  field :master_scenario_id
  field :master_scenario_version, :type => Integer
  field :read,                    :type => Boolean, :default => false
  
  embedded_in :scenario, :inverse_of => :scenario_alerts
  
  named_scope :unread, where(:read => false)
  
  def master_scenario
    ms = MasterScenario.for_display(master_scenario_id.to_s, :add => :versions)
    #condition is only necessary to support already created master_scenario.scenarios ...
    ms.version == master_scenario_version ? ms : ms.versions.detect { |v| v.version == master_scenario_version } if ms
  end
end
