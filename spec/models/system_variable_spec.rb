require File.dirname(__FILE__) + "/../spec_helper"

describe SystemVariable do
  before(:each) do
    @master_scenario  = Factory(:master_scenario, :user => user_with_role(:admin))
    @system_variable  = Factory.build(:system_variable, :master_scenario => @master_scenario)
  end
  
  it "should not be valid without required attributes" do
    @system_variable  = @master_scenario.system_variables.build
    @system_variable.should_not be_valid
    @system_variable.errors[:name].should_not be_empty
    @system_variable.errors[:display_name].should_not be_empty
    @system_variable.errors[:master_scenario].should be_empty
  end
  
  it "should not be valid without formatted fields" do
    @system_variable  = Factory.build(:system_variable, :master_scenario => @master_scenario, 
                        :min_value => "A", :default_value => "B", :max_value => "C", :type_code => 5)
    @system_variable.should_not be_valid
    @system_variable.errors[:min_value].should_not be_empty
    @system_variable.errors[:default_value].should_not be_empty
    @system_variable.errors[:max_value].should_not be_empty
    @system_variable.errors[:type_code].should_not be_empty
  end
  
  it "" do
    @system_variable.should be_valid
  end
  
end
