require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructor::VariablesController do

  before(:each) do
    @user                     = user_with_role(:instructor)
    @admin                    = user_with_role(:admin)
    @master_scenario          = Factory(:master_scenario, :user => @admin)
    @scenario                 = Factory(:scenario, :user => @user, :master_scenario => @master_scenario)
    @scenario_variable        = Factory(:scenario_variable, :scenario => @scenario)
    login_as(@user)
  end
  
  describe "GET index" do
    it "" do
      # get :index, :scenario_id => @scenario.id
      # response.should render_template(:index)
      # assigns(:scenario_variables).should eq(@scenario.scenario_variables)
    end
  end
  
  pending "Fix :index with controller stubbing when available"
  
  describe "GET show" do
    it "" do
      get :show, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should render_template(:show)
      assigns(:scenario_variable).should eq(@scenario_variable)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new, :scenario_id => @scenario.id
      response.should render_template(:new)
      assigns(:scenario_variable).should be_instance_of(ScenarioVariable)
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
        Scenario.find(@scenario.id).scenario_variables.size.should == @scenario_sys_vars + 1
      end
      
      it "redirects to the created scenario_variable" do
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable)
        response.should redirect_to(instructor_scenario_variable_path(@scenario, assigns(:scenario_variable)))
      end
    end
  
    describe "with invalid params (i.e. empty name)" do
      it "should render #new with errors" do
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable, :name => "")
        response.should render_template(:new)
      end
    end
    
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "updated var name" }
        @scenario.reload.scenario_variables.first.name.should == "updated var name"
      end
      
      it "redirects to the scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "scenerio var" }
        response.should redirect_to(instructor_scenario_variable_path(@scenario, @scenario_variable))
      end
    end

    describe "with invalid params (i.e. empty name)" do  
      it "should render #edit with errors" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "" }
        response.should render_template(:edit)
      end
    end
  end
  
  
  describe "DELETE destroy" do    
    it "destroys the requested scenario_variable" do
      @scenario_sys_vars = @scenario.scenario_variables.size
      delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      Scenario.find(@scenario.id).scenario_variables.size.should == @scenario_sys_vars - 1
    end
  
    it "redirects to the scenario_variables list" do
      delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should redirect_to(instructor_scenario_variables_path(@scenario))
    end
  end
  
  pending "Authorization & roles"

  describe "Authentication" do
    before(:each) { user_logout }
    
    it "should require a logged user" do
      authorize_actions do 
        response.should redirect_to(login_path)
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
  
  
  def mock_scenario_variable(attrs = {})
    @mock_scenario_variable ||= Factory(:scenario_variable, {:user => @user}.merge(attrs))
  end
end
