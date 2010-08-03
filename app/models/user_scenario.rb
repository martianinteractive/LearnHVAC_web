class UserScenario < ActiveRecord::Base
  belongs_to :user
  belongs_to :scenario
  
  validates_presence_of :user, :scenario
  validates_uniqueness_of :user_id, :scope => :scenario_id
end
