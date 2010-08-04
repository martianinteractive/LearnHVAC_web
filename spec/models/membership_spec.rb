require File.dirname(__FILE__) + "/../spec_helper"

describe Membership do
  before(:each) do
    @admin      = Factory(:admin)
    @instructor = Factory(:instructor)
    @group      = Factory(:group, :creator => @instructor)
    @ms         = Factory(:master_scenario, :user => @admin, :client_version => Factory(:client_version))
    @scenario   = Factory(:scenario, :master_scenario => @ms, :user => @instructor)
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
  
  # it "should validates uniqueness of group_student" do
  #   @membership.save
  #   membership = Factory.build(:membership, :group => @group, :student => @student)
  #   membership.should_not be_valid
  #   membership.errors[:student_id].should_not be_empty
  # end
  
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
  
end
