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
  
  describe ".split!" do
    before(:each) do
      @scenario_2 = Factory(:scenario, :master_scenario => @ms, :user => @instructor, :name => 'scenario_2')
      @scenario_3 = Factory(:scenario, :master_scenario => @ms, :user => @instructor, :name => 'scenario_3')
      
      Factory(:group_scenario, :group => @group, :scenario => @scenario)
      Factory(:group_scenario, :group => @group, :scenario => @scenario_2)
      Factory(:group_scenario, :group => @group, :scenario => @scenario_3)
      @group.reload
    end
    
    it "should create new group_memberships based on the associated group scenarios" do
      proc { @group_membership.split! }.should change(GroupMembership, :count).by(3)
    end
    
    it "should assign each scenario to group_memberships" do
      group_memberships = @group_membership.split!
      group_memberships.first.scenario.should == @scenario
      group_memberships.second.scenario.should == @scenario_2
      group_memberships.third.scenario.should == @scenario_3
    end
  end
  
end
