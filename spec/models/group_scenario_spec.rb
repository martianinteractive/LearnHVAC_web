require File.dirname(__FILE__) + "/../spec_helper"

describe GroupScenario do
  before(:each) do
    @instructor       = Factory(:user)
    ms                = Factory(:master_scenario, :user => Factory(:admin))
    @scenario_1       = Factory(:scenario, :name => "scena 1", :user => @instructor, :master_scenario => ms)
    @scenario_2       = Factory(:scenario, :name => "scena 2", :user => @instructor, :master_scenario => ms)
    @group            = Factory(:group, :creator => @instructor, :scenario_ids => [@scenario_1.id])
  end
  
  
  describe "Callbacks" do
    describe "after create" do
      before(:each) do
        @student          = Factory(:student)
        Factory(:group_membership, :group => @group, :member => @student, :scenario => @scenario_1)
        @group_scenario = Factory.build(:group_scenario, :group => @group, :scenario => @scenario_2)
      end
      
      it "should create new memberships if the group has students" do
         proc { @group_scenario.save }.should change(GroupMembership, :count).by(1)
      end
    end
  end
  
end
