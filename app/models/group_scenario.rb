class GroupScenario < ActiveRecord::Base
  include BelongsToDocument
  belongs_to :group
  belongs_to_document :scenario
  
  validates :group, :presence => true, :on => :update
  validates :scenario_id, :presence => true
  
  # This validation is being ignored from groups#create/update
  validates_uniqueness_of :scenario_id, :scope => :group_id
end
