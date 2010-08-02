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
      
  describe "Callbacks" do    
    describe "After create" do
      before(:each) do
        @group2 = Factory(:group, :name => "class2", :instructor => @instructor)
        @group3 = Factory(:group, :name => "class3", :instructor => @instructor)
        @group4 = Factory.build(:group, :name => "class4", :instructor => @instructor)
      end
      
      it "should set a unique valid code" do
        @group2.code.should_not be_nil
        @group2.code.should be_present
        @group3.code.should_not be_nil
        @group3.code.should be_present
        
        @group2.code.should_not equal(@group3.code)
      end
      
      it "should create a membership for the group owner/instructor" do
        proc { @group4.save }.should change(Membership, :count).by(1)
        membership = Membership.last
        membership.member.should == @group4.instructor
        membership.group.should == @group4        
      end
    end
  end
  
end
