class ScenarioSystemVariable
  include Mongoid::Document
  include SystemVariableFields
  
  belongs_to :scenario, :inverse_of => :scenario_system_variables
end
