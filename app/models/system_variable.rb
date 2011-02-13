class SystemVariable < Variable
  belongs_to :master_scenario, :foreign_key => "scenario_id" 
  
  validates_presence_of :master_scenario  
end
