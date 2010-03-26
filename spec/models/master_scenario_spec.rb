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
    
  context "Cloning" do
    
    before(:each) do
      Factory(:system_variable, :master_scenario => @master_scenario)
      Factory(:system_variable, :master_scenario => @master_scenario)
    end
    
    it "" do
      proc { @master_scenario.clone! }.should change(MasterScenario, :count).by(1)
    end
    
    it "should also clone the system variables" do
      ms_clon = @master_scenario.clone!
      ms_clon.system_variables.should have(@master_scenario.system_variables.count).variables
    end
    
    it "should name the cloned scenario as original_name_clon" do
      ms_clon = @master_scenario.clone!
      ms_clon.name.should == "#{@master_scenario.name}_clon"
    end
    
  end
      
end
