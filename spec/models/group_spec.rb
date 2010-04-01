require File.dirname(__FILE__) + "/../spec_helper"

describe Group do
  before(:each) do
    @instructor = Factory(:user)
    @group = Factory.build(:group, :instructor => @instructor)
    @group.group_scenarios.build(:scenario_id => "1")
    @group.save
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
  
  it "should not be valid when assigning the same scenario multiple times" do
    @group.group_scenarios.build(:scenario_id => "1")
    @group.should_not be_valid
    @group.errors[:scenarios].should_not be_empty
  end
  
  it "should validate code on update" do
    @group.save #creates the group. and sets a valid unique code.
    @group.code = ""
    @group.save
    @group.should_not be_valid
    @group.errors[:code].sort.should == ["can't be blank"]
  end
  
  describe "Destroy" do
    before(:each) do
      @group.save
      @group.memberships << Factory(:membership, :group => @group, :student => user_with_role(:student, 1, { :group_code => @group.code }))
      @group.memberships << Factory(:membership, :group => @group, :student => user_with_role(:student, 1, { :login => "student2", :email => "st2@st.com", :group_code => @group.code }))
    end
    
    it "should destroy the associated memberships" do
      proc { @group.destroy }.should change(Membership, :count).by(-2)
    end
  end
  
  describe "Callbacks" do    
    describe "After create" do
      before(:each) do
        @group2 = Factory.build(:group, :name => "class2", :instructor => @instructor)
        @group2.group_scenarios.build(:scenario_id => "1")
        @group3 = Factory.build(:group, :name => "class3", :instructor => @instructor)
        @group3.group_scenarios.build(:scenario_id => "1")
        @group2.save
        @group3.save
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
