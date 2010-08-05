require File.dirname(__FILE__) + "/../spec_helper"

describe ScenarioVariable do
  before(:each) do
    @master_scenario    = Factory(:master_scenario, :user => Factory(:admin))
    @scenario           = Factory(:scenario, :user => Factory(:instructor), :master_scenario => @master_scenario)
    @scenario_variable  = Factory.build(:scenario_variable)
  end
  
  it "should not be valid without scenario" do
    @scenario_variable.should_not be_valid
    @scenario_variable.scenario = @scenario
    @scenario_variable.should be_valid
  end
end
