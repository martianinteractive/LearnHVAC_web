require File.dirname(__FILE__) + "/../spec_helper"

describe Group do
  before(:each) do
    @instructor       = Factory(:user)
    @master_scenario  = Factory(:master_scenario, :user => Factory(:admin))
    @scenario1        = Factory(:scenario, :name => "scene 1", :user => @instructor, :master_scenario => @master_scenario)
    @group            = Factory(:group, :instructor => @instructor, :scenario_ids => [@scenario1.id])
  end
  
  it "" do
    @group.should be_valid
  end
  
  it "should not be valid without instructor, name" do
    @group.name = ""
    @group.instructor = nil
    @group.should_not be_valid
    [:name, :instructor].each { |gattr| @group.errors[gattr].sort.should == ["can't be blank"] }
  end
  
  it "should validate code on update" do
    @group.save #creates the group. and sets a valid unique code.
    @group.code = ""
    @group.save
    @group.should_not be_valid
    @group.errors[:code].sort.should == ["can't be blank"]
  end
  
  describe "Mongoid Associations" do    
    it "should return the associated documents" do
      @group.scenarios.should eq([@scenario1])
    end
    
    describe "re-assigning documents" do
      before(:each) { @scenario2 = Factory(:scenario, :name => "scene 2", :user => @instructor, :master_scenario => @master_scenario) }
      
      it "should show the current scenarios, but make db associations changes only when saving" do
        @group.scenario_ids = [@scenario2.id]
        @group.scenarios.should eq([@scenario2])
        @group.group_scenarios.where(:scenario_id => @scenario1.id).should have(1).group_scenario
        @group.save
        @group.scenarios.should eq([@scenario2])
        @group.group_scenarios.where(:scenario_id => @scenario1.id).should be_empty
        @group.group_scenarios.where(:scenario_id => @scenario2.id).should have(1).group_scenario
      end
      
      it "" do
        @group.scenario_ids = [@scenario1.id, @scenario2.id]
        @group.save
        @group.scenarios.should eq([@scenario1, @scenario2])
      end
      
      it "should not assign scenarios that don't belong to the group instructor" do
        @scenario2.user = Factory(:instructor, :login => "instructor2", :email => "inst2@inst.com")
        @scenario2.save
        @group.scenario_ids = [@scenario2.id]
        @group.should_not be_valid
        @group.errors[:base].should == ["invalid scenario"]
      end
      
      it "should uniquify documents_ids" do
        @group.scenario_ids = [@scenario1.id, @scenario1.id]
        @group.scenario_ids.should eq([@scenario1.id])
      end
      
    end
  end
  
  describe "Destroy" do
    before(:each) do
      @group.save
      @group.memberships << Factory(:membership, :group => @group, :student => Factory(:student, :group_code => @group.code)
      @group.memberships << Factory(:membership, :group => @group, :student => Factory(:student, :login => "student2", :email => "st2@st.com", :group_code => @group.code)
    end
    
    it "should destroy the associated memberships" do
      proc { @group.destroy }.should change(Membership, :count).by(-2)
    end
    
    it "should destroy the associated group_scenarios" do
      proc { @group.destroy }.should change(GroupScenario, :count).by(-1)
    end
  end
  
  describe "Callbacks" do    
    describe "After create" do
      before(:each) do
        @group2 = Factory(:group, :name => "class2", :instructor => @instructor, :scenario_ids => [@scenario1.id])
        @group3 = Factory(:group, :name => "class3", :instructor => @instructor, :scenario_ids => [@scenario1.id])
      end
      
      it "should set a unique valid code" do
        @group2.code.should_not be_nil
        @group2.code.should be_instance_of(String)
        @group3.code.should_not be_nil
        @group3.code.should be_instance_of(String)
        
        @group2.code.should_not equal(@group3.code)
      end
    end
  end
  
end
