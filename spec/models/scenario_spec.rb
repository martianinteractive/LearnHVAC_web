require File.dirname(__FILE__) + "/../spec_helper"

describe Scenario do
  
  before(:each) do
    @user            = Factory(:instructor)
    @admin           = Factory(:admin)
    @master_scenario = Factory(:master_scenario, :user => @admin)
    @scenario        = Factory.build(:scenario, :user => @user, :master_scenario => @master_scenario)
  end
  
  context "Validations" do
    before(:each) { @scenario = Factory.build(:scenario, :name => nil) }
    
    it "should be invalid without required attributes" do
      @scenario.should_not be_valid
      @scenario.errors[:user].should_not be_empty
      @scenario.errors[:master_scenario].should_not be_empty
      @scenario.errors[:name].should_not be_empty
    end
    
    it "should validate longterm dates" do
      @scenario.update_attributes(:longterm_start_date => 1.day.from_now.strftime("%m/%d/%Y"), :longterm_stop_date => Time.now.strftime("%m/%d/%Y}"), :realtime_start_datetime => 25.hours.from_now)
      @scenario.should_not be_valid
      @scenario.errors[:longterm_start_date].should == ["should be set before the longterm stop date"]
      @scenario.errors[:longterm_stop_date].should == ["should be set after the longterm start date"]
      @scenario.errors[:realtime_start_datetime].should == ["should be set between start and stop dates"]
      @scenario.update_attributes(:longterm_stop_date => 2.days.from_now.strftime("%m/%d/%Y"), :name => "scenario", :user => @user, :master_scenario => @master_scenario)
      @scenario.should be_valid
      @scenario.update_attributes(:realtime_start_datetime => 3.days.from_now.strftime("%m/%d/%Y}"))
      @scenario.should_not be_valid
      @scenario.errors[:realtime_start_datetime].should == ["should be set between start and stop dates"]
    end
    
    it "" do
      @scenario = Factory.build(:scenario, :name => "scenario", :user => @user, :master_scenario => @master_scenario)
      @scenario.should be_valid
    end
    
    it "should no be public by default" do
      @scenario.should_not be_public
    end
  end
  
  
  context "scopes" do
    before(:each) do
      @public_scenario    = Factory(:scenario, :user => @user, :master_scenario => @master_scenario, :public => true)
      @public_scenario2   = Factory(:scenario, :user => @user, :master_scenario => @master_scenario, :public => true)
      @private_sceneario  = Factory(:scenario, :user => @user, :master_scenario => @master_scenario, :public => false)
    end
    
    describe "public" do
      it "should only find public scenarios" do
        Scenario.public.should_not be_empty
        Scenario.public.all.to_a.should have(2).scenarios
        Scenario.public.all.to_a.should eq([@public_scenario, @public_scenario2])
      end
    end
  end
  
  context "Callbacks" do
    context "on create" do
      before(:each) do
        create_system_variables
      end
      
      it "should make a copy of the master_scenario.system_variables as scenario_variables" do
        @master_scenario.variables.should have_at_least(3).variables
        scenario_variables_count = @scenario.variables.count
        @scenario.save
        @scenario.variables.count.should == scenario_variables_count + @master_scenario.variables.count
      end
      
      it "should copy the system_variables attributes" do
        @scenario.save
        @scenario.variables.size.times do |i|
          @scenario.variables[i].name.should == @master_scenario.variables[i].name
        end
      end
      
      it "should create the syste_variables copies as istance of ScenarioVariable" do
        @scenario.save
        @scenario.variables.each { |sv| sv.should be_instance_of(ScenarioVariable) }
      end
      
      it "should create a membership for the group owner/instructor" do
        proc { @scenario.save }.should change(IndividualMembership, :count).by(1)
        user_scenario = IndividualMembership.last
        user_scenario.user.should == @scenario.user
        user_scenario.scenario.should == @scenario
      end
    end
  end
  
  def create_system_variables
    Factory(:system_variable, :name => "var 1", :master_scenario => @master_scenario)
    Factory(:system_variable, :name => "var 2", :master_scenario => @master_scenario)
    Factory(:system_variable, :name => "var 3", :master_scenario => @master_scenario)
  end
end
