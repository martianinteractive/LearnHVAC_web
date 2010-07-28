class SystemVariable < Variable
  belongs_to :master_scenario, :foreign_key => "scenario_id"   
end
