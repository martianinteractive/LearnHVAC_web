require File.dirname(__FILE__) + "/../spec_helper"

describe ScenarioVariable do
  before(:each) do
    @master_scenario    = Factory(:master_scenario, :user => user_with_role(:admin))
    @scenario           = Factory(:scenario, :user => user_with_role(:instructor), :master_scenario => @master_scenario)
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
                        :min_value => "A", :default_value => "B", :max_value => "C", :type_code => 5)
    @scenario_variable.should_not be_valid
    @scenario_variable.errors[:min_value].should_not be_empty
    @scenario_variable.errors[:default_value].should_not be_empty
    @scenario_variable.errors[:max_value].should_not be_empty
    @scenario_variable.errors[:type_code].should_not be_empty
  end
  
  it "" do
    @scenario_variable.should be_valid
  end
end
