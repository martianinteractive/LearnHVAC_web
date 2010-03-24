class MasterScenario < ActiveRecord::Base
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  include ScenarioFields
  
  has_many :system_variables
  
end
