class IndividualMembership < Membership
  validates_uniqueness_of :member_id, :scope => :scenario_id
end
