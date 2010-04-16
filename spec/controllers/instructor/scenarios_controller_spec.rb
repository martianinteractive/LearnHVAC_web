require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructor::ScenariosController do
  before(:each) do
    @admin           = user_with_role(:admin)
    @user            = user_with_role(:instructor)
    @master_scenario = Factory(:master_scenario, :user => @admin)
    @scenario        = Factory(:scenario, :user => @user, :master_scenario => @master_scenario) 
    login_as(@user)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:scenarios).should_not be_empty
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :id => @scenario.id
      response.should render_template(:show)
      assigns(:scenario).should eq(@scenario)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:scenario).should be_instance_of(Scenario)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :id => @scenario.id
      response.should render_template(:edit)
      assigns(:scenario).should eq(@scenario)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "should change the Scenario count" do
        proc{ post :create, :scenario => Factory.attributes_for(:scenario, :name => "new scenario", :master_scenario_id => @master_scenario.id) }.should change(Scenario, :count).by(1)
      end
      
      it "should assign the current user as the Scenario user" do
        post :create, :scenario => Factory.attributes_for(:scenario, :name => "new scenario", :master_scenario_id => @master_scenario.id)
        assigns(:scenario).user.should == @user
      end
  
      it "redirects to the created scenario" do
        post :create, :scenario => Factory.attributes_for(:scenario, :name => "new scenario", :master_scenario_id => @master_scenario.id)
        response.should redirect_to(instructor_scenario_path(assigns(:scenario)))
      end
    end
  
    describe "with invalid params" do
      it "should render #new with errors" do
        post :create, :scenario => Factory.attributes_for(:scenario, :name => "", :master_scenario_id => @master_scenario.id)
        response.should render_template(:new)
      end
    end
    
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested scenario" do
        put :update, :id => @scenario.id, :scenario => { :name => "Inst var"}
        @scenario.reload.name.should == "Inst var"
      end
      
      it "redirects to the scenario" do
        put :update, :id => @scenario.id, :scenario => { :name => "Inst var" }
        response.should redirect_to(instructor_scenario_path(@scenario.id))
      end
    end

    describe "with invalid params" do  
      it "should render #edit with errors" do
        put :update, :id => @scenario.id, :scenario => { :name => "" }
        response.should render_template(:edit)
      end
    end
  end
  
  
  describe "DELETE destroy" do    
    it "destroys the requested scenario" do
      proc { delete :destroy, :id => @scenario.id }.should change(Scenario, :count).by(-1)
    end
  
    it "redirects to the scenarios list" do
      delete :destroy, :id => @scenario.id
      response.should redirect_to(instructor_scenarios_path)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      user_logout
    end
    
    it "should require an admin user for all actions" do
      authorize_actions do
        response.should redirect_to(login_path)
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
end
