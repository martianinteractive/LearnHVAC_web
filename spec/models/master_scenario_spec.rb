require File.dirname(__FILE__) + "/../spec_helper"

describe MasterScenario do
  before(:each) do
    @admin           = user_with_role(:admin)
    @master_scenario = Factory(:master_scenario, :user => @admin)
  end
  
  context "Validations" do
    before(:each) { @master_scenario = Factory.build(:scenario, :name => nil) }
    
    it "should be invalid without required attributes" do
      @master_scenario.should_not be_valid
      @master_scenario.errors[:user].should_not be_empty
      @master_scenario.errors[:name].should_not be_empty
    end
    
    it "" do
      @master_scenario = Factory.build(:master_scenario, :name => "m scenario", :user => @admin)
      @master_scenario.should be_valid
    end
    
  end
end
