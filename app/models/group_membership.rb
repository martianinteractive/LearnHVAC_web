class GroupMembership < Membership  
  validates_presence_of :group
  validates_uniqueness_of :member_id, :scope => [:group_id, :scenario_id]
    
  def split!
    return false unless group and member 
    group.scenarios.each do |s|
      self.class.create(:member => self.member, :group => self.group, :scenario => s)
    end
    group.memberships
  end
  
end
