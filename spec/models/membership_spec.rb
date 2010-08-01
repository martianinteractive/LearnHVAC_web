require File.dirname(__FILE__) + "/../spec_helper"

describe Membership do
  before(:each) do
    @student    = Factory(:student)
    @group      = Factory(:group, :instructor => Factory(:instructor))
    @membership = Factory.build(:membership, :group => @group, :student => @student)
  end
  
  it "" do
    @membership.should be_valid
  end
  
  it "should not be valid without group" do
    @membership.group = nil
    @membership.should_not be_valid
    @membership.errors[:group].should_not be_empty
  end
  
  it "should not be valid without student" do
    @membership.student = nil
    @membership.should_not be_valid
    @membership.errors[:student].should_not be_empty
  end
  
  it "should validates uniqueness of group_student" do
    @membership.save
    membership = Factory.build(:membership, :group => @group, :student => @student)
    membership.should_not be_valid
    membership.errors[:student_id].should_not be_empty
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
  
end
