class SystemVariable
  include Mongoid::Document
  include SystemVariableFields
  
  belongs_to :master_scenario
end
