class VersionNote
  include Mongoid::Document
  include Mongoid::Timestamps
    
  field :master_scenario_version
  field :description
  
  embedded_in :master_scenario, :inverse_of => :version_notes
  
  validates_presence_of :master_scenario_version
end