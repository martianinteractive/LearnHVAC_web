class MasterScenario
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :description

  has_many :system_variables
  belongs_to_related :user
end
