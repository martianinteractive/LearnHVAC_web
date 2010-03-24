class MasterScenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include ScenarioFields
  
  has_many :system_variables
  
end
