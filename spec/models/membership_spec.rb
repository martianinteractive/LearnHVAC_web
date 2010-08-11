require File.dirname(__FILE__) + "/../spec_helper"

describe Membership do
  before(:each) do
    @admin      = Factory(:admin)
    @instructor = Factory(:instructor)
    @ms         = Factory(:master_scenario, :user => @admin, :client_version => Factory(:client_version))
    @scenario   = Factory(:scenario, :master_scenario => @ms, :user => @instructor)
    @group      = Factory(:group, :creator => @instructor, :scenario_ids => [@scenario.id])
    @membership = Factory.build(:membership, :scenario => @scenario, :member => @admin)
  end
  
  it "" do
    @membership.should be_valid
  end
  
  it "should not be valid without scenario" do
    @membership.scenario = nil
    @membership.should_not be_valid
    @membership.errors[:scenario].should_not be_empty
  end
  
  it "should not be valid without member" do
    @membership.member = nil
    @membership.should_not be_valid
    @membership.errors[:member].should_not be_empty
  end
    
  it "should be recently_created if created less than 20 minutes ago" do
    @membership.save
    @membership.should be_recently_created
    @membership.expects(:created_at).returns(19.minutes.ago)
    @membership.should be_recently_created
  end
  
  it "should not be recently_create if created more than 20 minutes ago" do
    @membership.save
    @membership.expects(:created_at).returns(20.minutes.ago)
    @membership.should_not be_recently_created
  end
  
  describe "callbacks" do
    describe "before_create" do
      it "should set the member role" do
        @membership.member_role.should be_nil
        @membership.save
        @membership.member_role.should == @admin.role.to_s
      end
    end
  end
  
end
