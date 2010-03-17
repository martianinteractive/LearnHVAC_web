class ScenarioSystemVariable < SystemVariable
  belongs_to :scenario, :inverse_of => :scenario_system_variables
end
