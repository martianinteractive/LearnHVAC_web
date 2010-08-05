require File.dirname(__FILE__) + "/../spec_helper"

describe Group do
  before(:each) do
    @instructor       = Factory(:user)
    @master_scenario  = Factory(:master_scenario, :user => Factory(:admin))
    @scenario_1        = Factory(:scenario, :name => "scene 1", :user => @instructor, :master_scenario => @master_scenario)
    @group            = Factory(:group, :creator => @instructor, :scenario_ids => [@scenario_1.id])
  end
  
  it "" do
    @group.should be_valid
  end
  
  it "should not be valid without instructor, name" do
    @group.name = ""
    @group.creator = nil
    @group.should_not be_valid
    [:name, :creator].each { |gattr| @group.errors[gattr].sort.should == ["can't be blank"] }
  end
  
  it "should validate code on update" do
    @group.save #creates the group. and sets a valid unique code.
    @group.code = ""
    @group.save
    @group.should_not be_valid
    @group.errors[:code].sort.should == ["can't be blank"]
  end
  
  describe ".split!" do
    before(:each) do
      ms = Factory(:master_scenario, :user => @instructor)
      @scenario_2 = Factory(:scenario, :master_scenario => ms, :user => @instructor, :name => 'scenario_2')
      @scenario_3 = Factory(:scenario, :master_scenario => ms, :user => @instructor, :name => 'scenario_3')
      @student = Factory(:student)
      
      Factory(:group_scenario, :group => @group, :scenario => @scenario_2)
      Factory(:group_scenario, :group => @group, :scenario => @scenario_3)

      @group.reload
    end
    
    it "should create new group_membership for each scenario of the group" do
      proc { @group.create_memberships(@student) }.should change(GroupMembership, :count).by(3)
    end
    
    it "should assign each scenario to group_memberships" do
      group_memberships = @group.create_memberships(@student)
      group_memberships.first.scenario.should == @scenario_1
      group_memberships.second.scenario.should == @scenario_2
      group_memberships.third.scenario.should == @scenario_3
    end
  end
      
  describe "Callbacks" do    
    describe "After create" do
      before(:each) do
        @group2 = Factory(:group, :name => "class2", :creator => @instructor)
        @group3 = Factory(:group, :name => "class3", :creator => @instructor)
        @group4 = Factory.build(:group, :name => "class4", :creator => @instructor)
      end
      
      it "should set a unique valid code" do
        @group2.code.should_not be_nil
        @group2.code.should be_present
        @group3.code.should_not be_nil
        @group3.code.should be_present
        
        @group2.code.should_not equal(@group3.code)
      end
      
      # it "should create a membership for the group owner/instructor" do
      #   proc { @group4.save }.should change(Membership, :count).by(1)
      #   membership = Membership.last
      #   membership.member.should == @group4.creator
      #   membership.group.should == @group4        
      # end
    end
  end
  
end
