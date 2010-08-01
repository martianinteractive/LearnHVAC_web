require File.dirname(__FILE__) + "/../spec_helper"

describe ScenarioVariable do
  before(:each) do
    @master_scenario    = Factory(:master_scenario, :user => Factory(:admin))
    @scenario           = Factory(:scenario, :user => Factory(:instructor), :master_scenario => @master_scenario)
    @scenario_variable  = Factory.build(:scenario_variable, :scenario => @scenario)
  end
  
  it "should not be valid without required attributes" do
    @scenario_variable  = @scenario.scenario_variables.build
    @scenario_variable.should_not be_valid
    @scenario_variable.errors[:name].should_not be_empty
    @scenario_variable.errors[:display_name].should_not be_empty
    @scenario_variable.errors[:scenario].should be_empty
  end
  
  it "should not be valid without formatted fields" do
    @scenario_variable  = Factory.build(:scenario_variable, :scenario => @scenario, 
                        :low_value => "A", :initial_value => "B", :high_value => "C", :io_type => 5)
    @scenario_variable.should_not be_valid
    @scenario_variable.errors[:low_value].should_not be_empty
    @scenario_variable.errors[:initial_value].should_not be_empty
    @scenario_variable.errors[:high_value].should_not be_empty
    @scenario_variable.errors[:io_type].should_not be_empty
  end
  
  it "" do
    @scenario_variable.should be_valid
  end
end
