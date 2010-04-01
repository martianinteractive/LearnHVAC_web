require File.dirname(__FILE__) + "/../spec_helper"

describe Membership do
  before(:each) do
    @student    = user_with_role(:student)
    @group      = Factory.build(:group, :instructor => user_with_role(:instructor))
    @group.group_scenarios.build(:scenario_id => "1")
    @group.save
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
  
end
