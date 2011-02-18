require File.dirname(__FILE__) + "/../spec_helper"

describe Membership do
  it { should belong_to(:member) }
  it { should belong_to(:scenario) }
  it { should belong_to(:group) }
  
  it { should validate_presence_of(:member) }
  it { should validate_presence_of(:scenario) }
  
  context "new membership" do
    let(:membership) { Factory(:valid_membership) }
    
    it { membership.should be_valid }
    it { membership.errors.should be_empty }
    it { membership.type.should be_nil }
    it { membership.member.should_not be_nil }
    it { membership.scenario.should_not be_nil }
    it { membership.member_role.should == membership.member.role.to_s }
    it { membership.should be_recently_created }
  end
  
  context "old membership" do
    let(:membership) { Factory(:valid_membership, :created_at => 1.hour.ago) }
    
    it { membership.should_not be_recently_created }
  end
  
end
