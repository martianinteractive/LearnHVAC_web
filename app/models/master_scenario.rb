class MasterScenario
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :description

  has_many :system_variables
  has_many_related :scenarios
  belongs_to_related :user
  
  validates_presence_of :name, :user
  
end
