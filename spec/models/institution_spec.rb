require File.dirname(__FILE__) + "/../spec_helper"

describe Institution do
  before(:each) do
    @institution = Factory.build(:institution)
  end
  
  it "" do
    @institution.should be_valid
  end
  
  it "" do
    Institution::CATEGORIES.should have(4).categories
  end
  
  it "should not be valid without name" do
    @institution.name = ""
    @institution.should_not be_valid
    @institution.errors[:name].sort.should == ["can't be blank"]
  end
  
  describe "scopes" do
    describe "withwith_public_scenarios" do
      before(:each) do
        @institution.save
        @mit        = Factory(:institution, :name => "MIT")
        @willy      = Factory(:instructor, :institution => @institution)
        @wally      = Factory(:instructor, :login => "wally", :email => "wally@hvac.org", :institution => @mit)
        ms          = Factory(:master_scenario, :user => Factory(:admin))
        
        @willy_scenario   = Factory(:scenario, :public => false, :user => @willy, :master_scenario => ms)
        @wally_scenario   = Factory(:scenario, :public => true, :user => @wally, :master_scenario => ms)
      end
      
      it "should find institutions with public scenarios" do
        with_public_scenarios = Institution.with_public_scenarios
        with_public_scenarios.should have(1).institution
        with_public_scenarios.first.should == @mit
      end
    end
  end
  
  describe "Destroy" do
    before(:each) do
      @institution.users << Factory(:user, :login => "james", :email => "james@lhvac.com")
      @institution.users << Factory(:user, :login => "joe", :email => "joe@lhvac.com")
      @institution.save
    end
    
    it "should destroy the associated users" do
      proc { @institution.destroy }.should change(User, :count).by(-2)
    end
  end
  
end
