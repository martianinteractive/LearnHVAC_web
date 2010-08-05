class GroupScenario < ActiveRecord::Base
  belongs_to :group
  belongs_to :scenario
  
  validates_presence_of :group, :scenario
  validates_uniqueness_of :scenario_id, :scope => :group_id
  
  after_create :create_memberships
  
  private
  
  def create_memberships
    group.members.each { |member| group.memberships.create(:scenario => self.scenario, :member => member) }
  end
  
end
