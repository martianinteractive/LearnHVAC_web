require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::SystemVariablesController do

  before(:each) do
    admin_login
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
      it "should change the master_scenario.system_variables count" do
        system_variables_count = @master_scenario.system_variables.count
        post :create, :master_scenario_id => @master_scenario.id, :system_variable => Factory.attributes_for(:system_variable, :name => "_new system var")
        MasterScenario.find(@master_scenario.id).system_variables.count.should == system_variables_count + 1
      end
  
      it "redirects to the created system_variable" do
        post :create, :master_scenario_id => @master_scenario.id, :system_variable => Factory.attributes_for(:system_variable, :name => "_new system var")
        response.should redirect_to(admin_master_scenario_system_variable_path(@master_scenario, assigns(:system_variable)))
      end
    end
  
    pending "Define invalid attrs for system var"
    describe "with invalid params" do
    end
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested master_scenario.system_variables count" do
        put :update, :master_scenario_id => @master_scenario.id, :id => @system_variable.id, :system_variable => { :name => "Cold var" }
        MasterScenario.find(@master_scenario.id).system_variables.first.name.should == "Cold var"
      end
      
      it "redirects to the system_variable" do
        put :update, :master_scenario_id => @master_scenario.id, :id => @system_variable.id, :system_variable => { :name => "Cold var" }
        response.should redirect_to(admin_master_scenario_system_variable_path(@master_scenario, @system_variable))
      end
    end
    
    pending "Define invalid attrs for system var"
    describe "with invalid params" do  
    end
  end
  
  
  describe "DELETE destroy" do
    it "destroys the requested SystemVariable" do
      system_variables_count = @master_scenario.system_variables.count
      delete :destroy, :master_scenario_id => @master_scenario.id, :id => @system_variable.id
      MasterScenario.find(@master_scenario.id).system_variables.count.should == system_variables_count - 1
    end
  
    it "redirects to the system_variables list" do
      delete :destroy, :master_scenario_id => @master_scenario.id, :id => @system_variable.id
      response.should redirect_to(admin_master_scenario_system_variables_path(@master_scenario))
    end
  end
  
  describe "Authorization" do
    it "should require an authenticated admin for all actions" do
      @admin.role_code = User::ROLES[:student]
      @admin.save
      authorize_actions do
        response.should redirect_to(default_path_for(@admin))
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
end
