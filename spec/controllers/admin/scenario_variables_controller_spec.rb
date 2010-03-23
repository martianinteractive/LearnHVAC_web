require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::ScenarioVariablesController do
  
  before(:each) do
    @instructor               = Factory.build(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    @instructor.role_code     = User::ROLES[:instructor]
    @instructor.save
    @scenario                 = Factory(:scenario, :user => @instructor)
    @scenario_variable        = Factory(:scenario_variable, :scenario => @scenario)
    admin_login
  end
  
  describe "GET index" do
    it "" do
      get :index, :scenario_id => @scenario.id
      response.should render_template(:index)
      assigns(:scenario_variables).should eq(@scenario.scenario_variables)
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
      
      it "should change the scenario.scenario_variables count" do
        @scenario_sys_vars = @scenario.scenario_variables.size
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable, :name => "new scen. sys var")
        @scenario.reload["scenario_variables"].size.should == @scenario_sys_vars + 1
      end
      
      it "redirects to the created scenario_variable" do
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable)
        response.should redirect_to(admin_scenario_scenario_variable_path(@scenario, assigns(:scenario_variable)))
      end
    end
  
    pending "Define invalid attrs for scenario_variable"
    describe "with invalid params" do
    end
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "updated var name" }
        @scenario.reload["scenario_variables"].first["name"].should == "updated var name"
      end
      
      it "redirects to the scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "scenerio var" }
        response.should redirect_to(admin_scenario_scenario_variable_path(@scenario, @scenario_variable))
      end
    end
    
    pending "Define invalid attrs for Instructor system var"
    describe "with invalid params" do  
    end
  end
  
  describe "DELETE destroy" do    
    it "destroys the requested scenario_variable" do
      @scenario_sys_vars = @scenario.scenario_variables.size
      delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      @scenario.reload["scenario_variables"].size.should == @scenario_sys_vars - 1
    end
  
    it "redirects to the scenario_variables list" do
      delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should redirect_to(admin_scenario_scenario_variables_path(@scenario))
    end
  end
  
  describe "Authentication" do
    before(:each) { user_logout; login_as(@instructor) }
    
    it "should require a logged admin" do
      authorize_actions do 
        response.should redirect_to(default_path_for(@instructor))
        flash[:notice].should == "You don't have the privileges to access this page"
      end
    end
  end
  
  
end
