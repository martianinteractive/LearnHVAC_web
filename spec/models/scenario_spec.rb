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
      @scenario.update_attributes(:longterm_start_date => 1.day.from_now.to_date, :longterm_stop_date => Date.today, :realtime_start_datetime => 25.hours.from_now)
      @scenario.should_not be_valid
      @scenario.errors[:longterm_start_date].should == ["should be set before the longterm stop date"]
      @scenario.errors[:longterm_stop_date].should == ["should be set after the longterm start date"]
      @scenario.errors[:realtime_start_datetime].should == ["should be set between start and stop dates"]
      @scenario.update_attributes(:longterm_stop_date => 2.days.from_now.to_date, :realtime_start_datetime => 1.day.from_now.to_date, :name => "scenario", :user => @user, :master_scenario => @master_scenario)
      @scenario.should be_valid
      @scenario.update_attributes(:realtime_start_datetime => 3.days.from_now.to_date)
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
        membership = IndividualMembership.last
        membership.member.should == @scenario.user
        membership.scenario.should == @scenario
      end 
      
      it "should update the creator membership when the creator changes" do
        @scenario.save
        membership = @scenario.individual_memberships.find_by_member_id(@user.id)
        @scenario.update_attributes(:user => @admin)
        membership.reload.member_id.should == @admin.id
      end
      
      it "should destroy the creator membership when the creator changes AND the new creator already has membership" do
        @scenario.save
        Factory(:individual_membership, :member => @admin, :scenario => @scenario)
        proc { @scenario.update_attributes(:user => @admin) }.should change(IndividualMembership, :count).by(-1)
      end
    end
  end
  
  def create_system_variables
    Factory(:system_variable, :name => "var 1", :master_scenario => @master_scenario)
    Factory(:system_variable, :name => "var 2", :master_scenario => @master_scenario)
    Factory(:system_variable, :name => "var 3", :master_scenario => @master_scenario)
  end
end
