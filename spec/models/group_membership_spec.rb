require File.dirname(__FILE__) + "/../spec_helper"

describe GroupMembership do
  before(:each) do
    @instructor       = Factory(:instructor)
    @group            = Factory(:group, :creator => @instructor)
    @student          = Factory(:student)
    @ms               = Factory(:master_scenario, :user => @instructor)
    @scenario         = Factory(:scenario, :master_scenario => @ms, :user => @instructor)
    
    @group_membership = GroupMembership.new(:group => @group, :member => @student)
  end
  
  it "should validate uniqueness of [:group_id, :member_id, :scenario_id]" do
    @group_membership.scenario = @scenario
    @group_membership.should be_valid
    @group_membership.save
    group_membership = GroupMembership.new(:group => @group, :member => @student, :scenario => @scenario)
    group_membership.should_not be_valid
    group_membership.errors.values.to_s.should == "has already been taken"
  end
    
end
