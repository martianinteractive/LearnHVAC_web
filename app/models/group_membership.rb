class GroupMembership < Membership  
  validates_presence_of :group
  validates_uniqueness_of :member_id, :scope => [:group_id, :scenario_id]  
end
