require File.dirname(__FILE__) + "/../spec_helper"

describe Scenario do
  
  before(:each) do
    @user = user_with_role(:instructor)
    @scenario = Factory.build(:scenario, :user => @user)
  end
      
  context "Callbacks" do
    context "on create" do
      before(:each) do
        @admin = user_with_role(:admin)
        @master_scenario = Factory(:master_scenario, :user => @admin)
        create_system_variables
        @scenario.master_scenario = @master_scenario
      end
      
      it "should make a copy of the master_scenario.system_variables as scenario_variables" do
        @master_scenario.system_variables.should have_at_least(3).variables
        scenario_variables_count = @scenario.scenario_variables.count
        @scenario.save
        @scenario.scenario_variables.count.should == scenario_variables_count + @master_scenario.system_variables.count
      end
      
      it "should copy the system_variables attributes" do
        @scenario.save
        @scenario.scenario_variables.size.times do |i|
          @scenario.scenario_variables[i].name.should == @master_scenario.system_variables[i].name
        end
      end
      
      it "should create the syste_variables copies as istance of ScenarioVariable" do
        @scenario.save
        @scenario.scenario_variables.each { |sv| sv.should be_instance_of(ScenarioVariable) }
      end
      
    end
  end
  
  def create_system_variables
    Factory(:system_variable, :name => "var 1", :master_scenario => @master_scenario)
    Factory(:system_variable, :name => "var 2", :master_scenario => @master_scenario)
    Factory(:system_variable, :name => "var 3", :master_scenario => @master_scenario)
  end
end
