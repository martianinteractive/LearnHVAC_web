class VersionNote
  include Mongoid::Document
  include Mongoid::Timestamps
    
  field :master_scenario_version
  field :description
  
  embedded_in :master_scenario, :inverse_of => :version_note
  
  validates_presence_of :description, :master_scenario
  
  before_save :set_master_scenario_version
  
  private
  
  def set_master_scenario_version
    self.master_scenario_version = master_scenario.version
  end
  
end
