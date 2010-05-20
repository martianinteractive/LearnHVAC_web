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
                        :low_value => "A", :initial_value => "B", :high_value => "C", :io_type => 5)
    @system_variable.should_not be_valid
    @system_variable.errors[:low_value].should_not be_empty
    @system_variable.errors[:initial_value].should_not be_empty
    @system_variable.errors[:high_value].should_not be_empty
    @system_variable.errors[:io_type].should_not be_empty
  end
  
  it "" do
    @system_variable.should be_valid
  end
  
end
