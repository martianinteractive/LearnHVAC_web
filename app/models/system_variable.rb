class SystemVariable
  include Mongoid::Document
  include SystemVariableFields
  
  belongs_to_related :user
end
