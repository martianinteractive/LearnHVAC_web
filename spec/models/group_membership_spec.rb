require File.dirname(__FILE__) + "/../spec_helper"

describe GroupMembership do
  subject { Factory(:group_membership, :scenario => Factory(:valid_scenario), :member => Factory(:guest), :group => Factory(:valid_group))}
  
  it { should validate_presence_of(:group) }
  it { should validate_uniqueness_of(:member_id).scoped_to([:group_id, :scenario_id])}
end
