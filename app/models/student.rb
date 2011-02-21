class Student < User
  after_create :create_membership, :deliver_activation_instructions!
  
  before_validation(:on => :create) do
    self.active = false
    self.role_code = User::ROLES[:student]
    self.require_agreement_acceptance!
  end
  
  def create_membership
    group = Group.find_by_code(group_code)
    group.create_memberships(self)
  end
end