class GroupScenario < ActiveRecord::Base
  belongs_to :group
  belongs_to :scenario
  
  validates_presence_of :group, :scenario
    
  # This validation is being ignored from groups#create/update
  validates_uniqueness_of :scenario_id, :scope => :group_id
end
