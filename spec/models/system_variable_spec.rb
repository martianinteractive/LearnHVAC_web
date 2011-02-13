require File.dirname(__FILE__) + "/../spec_helper"

describe SystemVariable do
  before(:each) do
    @master_scenario  = Factory(:master_scenario, :user => Factory(:admin))
    @system_variable  = Factory.build(:system_variable)
  end
  
  it "should not be valid without master_scenario" do
    @system_variable.should_not be_valid
    @system_variable.master_scenario = @master_scenario
    @system_variable.should be_valid
  end
  
end
