require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::SystemVariablesController do

  before(:each) do
    @admin = Factory(:admin)
    login_as(@admin)
    @master_scenario = Factory(:master_scenario, :user => @admin)
    @system_variable = Factory(:system_variable, :master_scenario => @master_scenario)
  end
  
  describe "GET index" do
    it "" do
      get :index, :master_scenario_id => @master_scenario.id
      response.should render_template(:index)
      assigns(:system_variables).should_not be_empty
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :master_scenario_id => @master_scenario.id, :id => @system_variable.id
      response.should render_template(:show)
      assigns(:system_variable).should eq(@system_variable)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new, :master_scenario_id => @master_scenario.id
      response.should render_template(:new)
      assigns(:system_variable).should be_instance_of(SystemVariable)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :master_scenario_id => @master_scenario.id, :id => @system_variable.id
      response.should render_template(:edit)
      assigns(:system_variable).should eq(@system_variable)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "should change the master_scenario.variables count" do
        variables_count = @master_scenario.variables.count
        post :create, :master_scenario_id => @master_scenario.id, :system_variable => Factory.attributes_for(:system_variable, :name => "_new system var")
        MasterScenario.find(@master_scenario.id).variables.count.should == variables_count + 1
      end
  
      it "redirects to the created system_variable" do
        post :create, :master_scenario_id => @master_scenario.id, :system_variable => Factory.attributes_for(:system_variable, :name => "_new system var")
        response.should redirect_to(admins_master_scenario_system_variable_path(@master_scenario, assigns(:system_variable)))
      end
    end
  
    describe "with invalid params" do
      it "" do
        proc { 
          post :create, :master_scenario_id => @master_scenario.id, :system_variable => { } 
        }.should_not change(@master_scenario.reload.variables, :count)
      end
      
      it "" do
        post :create, :master_scenario_id => @master_scenario.id, :system_variable => { }
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested master_scenario.variables count" do
        put :update, :master_scenario_id => @master_scenario.id, :id => @system_variable.id, :system_variable => { :name => "Cold var" }
        MasterScenario.find(@master_scenario.id).variables.first.name.should == "Cold var"
      end
      
      it "redirects to the system_variable" do
        put :update, :master_scenario_id => @master_scenario.id, :id => @system_variable.id, :system_variable => { :name => "Cold var" }
        response.should redirect_to(admins_master_scenario_system_variable_path(@master_scenario, @system_variable))
      end
    end
    
    describe "with invalid params" do 
      it "" do
        put :update, :master_scenario_id => @master_scenario.id, :id => @system_variable.id, :system_variable => { :name => "" }
        response.should render_template(:edit)
      end
    end
  end
  
  describe "PUT update_status" do
    before(:each) do
      @system_variable.update_attribute(:disabled, false)
    end
    
    it "should mass disable system variables" do
      v1 = Factory(:system_variable, :disabled => false, :master_scenario => @master_scenario)
      v2 = Factory(:system_variable, :disabled => false, :master_scenario => @master_scenario)
      v3 = Factory(:system_variable, :disabled => false, :master_scenario => @master_scenario)
      SystemVariable.where(:disabled => false).should have(4).vars
      put :update_status, :master_scenario_id => @master_scenario.id, :system_variables => [v1.id, v2.id, v3.id], :disable => 1
      SystemVariable.where(:disabled => false).should have(1).var
      [v1.reload, v2.reload, v3.reload].each { |v| v.should be_disabled }
    end
    
    it "should mass enable system variables" do
      v1 = Factory(:system_variable, :disabled => true, :master_scenario => @master_scenario)
      v2 = Factory(:system_variable, :disabled => true, :master_scenario => @master_scenario)
      SystemVariable.where(:disabled => true).should have(2).vars
      put :update_status, :master_scenario_id => @master_scenario.id, :system_variables => [v1.id, v2.id]
      SystemVariable.where(:disabled => true).should have(0).vars
      [v1.reload, v2.reload].each { |v| v.should_not be_disabled }
    end
  end
  
  describe "DELETE destroy" do
    it "destroys the requested SystemVariable" do
      variables_count = @master_scenario.variables.count
      delete :destroy, :master_scenario_id => @master_scenario.id, :id => @system_variable.id
      MasterScenario.find(@master_scenario.id).variables.count.should == variables_count - 1
    end
  
    it "redirects to the variables list" do
      delete :destroy, :master_scenario_id => @master_scenario.id, :id => @system_variable.id
      response.should redirect_to([:admins, @master_scenario, :system_variables])
    end
  end
  
  describe "Authorization" do
    it "should require an authenticated admin for all actions" do
      user_logout
      
      authorize_actions(:master_scenario_id => @master_scenario.id, :id => @system_variable.id) do
        response.should redirect_to(login_path)
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
end
