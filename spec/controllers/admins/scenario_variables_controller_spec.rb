require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::ScenarioVariablesController do
  
  before(:each) do
    @admin              = Factory(:admin)
    @instructor         = Factory(:instructor)
    @master_scenario    = Factory(:master_scenario, :user => @admin)
    @scenario           = Factory(:scenario, :user => @instructor, :master_scenario => @master_scenario)
    @scenario_variable  = Factory(:scenario_variable, :scenario => @scenario)
    login_as(@admin)
  end
  
  describe "GET index" do
    it "" do
      get :index, :scenario_id => @scenario.id
      response.should render_template(:index)
      assigns(:scenario_variables).should eq(Scenario.find(@scenario.id).variables)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new, :scenario_id => @scenario.id
      response.should render_template(:new)
      assigns(:scenario_variable).should be_instance_of(ScenarioVariable)
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should render_template(:show)
      assigns(:scenario_variable).should eq(@scenario_variable)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should render_template(:edit)
      assigns(:scenario_variable).should eq(@scenario_variable)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      
      it "should change the scenario.variables count" do
        @scenario_sys_vars = Scenario.find(@scenario.id).variables.size
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable, :name => "new scen. sys var")
        Scenario.find(@scenario.id).variables.size.should == @scenario_sys_vars + 1
      end
      
      it "redirects to the created scenario_variable" do
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable)
        response.should redirect_to(admins_scenario_scenario_variable_path(@scenario, assigns(:scenario_variable)))
      end
    end
  
    describe "with invalid params" do
      it "" do
        @scenario_sys_vars = Scenario.find(@scenario.id).variables.size
        post :create, :scenario_id => @scenario.id, :scenario_variable => { }
        Scenario.find(@scenario.id).variables.size.should == @scenario_sys_vars
      end
      
      it "" do
        post :create, :scenario_id => @scenario.id, :scenario_variable => { }
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "updated var name" }
        Scenario.find(@scenario.id).variables.first.name.should == "updated var name"
      end
      
      it "redirects to the scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "scenerio var" }
        response.should redirect_to(admins_scenario_scenario_variable_path(@scenario, @scenario_variable))
      end
    end
    
    describe "with invalid params" do  
      it "should description" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :scenario_id => " " }
        response.should render_template(:edit)
      end
    end
  end
  
  describe "DELETE destroy" do    
    it "destroys the requested scenario_variable" do
      @scenario_sys_vars = Scenario.find(@scenario.id).variables.size
      delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      Scenario.find(@scenario.id).variables.size.should == @scenario_sys_vars - 1
    end
  
    it "redirects to the variables list" do
      delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should redirect_to(admins_scenario_scenario_variables_path(@scenario))
    end
  end
  
  describe "Authentication" do
    before(:each) { user_logout; login_as(@instructor) }
    
    it "should require a logged admin" do
      authorize_actions(:scenario_id => @scenario.id, :id => @scenario_variable.id) do 
        response.should be_redirect
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
  
  
end
