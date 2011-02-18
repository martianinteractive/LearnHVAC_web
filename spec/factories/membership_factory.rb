Factory.define :membership do |membership|
end

Factory.define :group_membership do |group_membership|
end

Factory.define :individual_membership do |individual_membership|
end

Factory.define :valid_membership, :class => Membership do |membership|
  membership.scenario { Scenario.first || Factory(:valid_scenario) }
  membership.member { Factory(:guest) }
end