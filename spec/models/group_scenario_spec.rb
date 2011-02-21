require File.dirname(__FILE__) + "/../spec_helper"

describe GroupScenario do
  
  it { should belong_to(:group) }
  it { should belong_to(:scenario) }
  
  it { should validate_presence_of(:group) }
  it { should validate_presence_of(:scenario) }
  
  context do
    subject { Factory(:group_scenario) }
    it { should validate_uniqueness_of(:scenario_id).scoped_to(:group_id) }
  end
  
  context do
    let(:group) { Factory(:valid_group) }
    let(:scenario) { Factory(:valid_scenario) }
    let(:student) { Factory(:student, :group_code => group.code) }
    let(:group_membership) { Factory(:group_membership, :group => group, :member => student, :scenario => group.scenarios.first) }
    let(:group_scenario) { Factory.build(:group_scenario, :group => group, :scenario => scenario) }
    
    it { expect { group_scenario.save! }.to change(GroupMembership, :count).by(1) }
  end
end
