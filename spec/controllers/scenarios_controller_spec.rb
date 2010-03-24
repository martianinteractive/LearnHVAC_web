require File.dirname(__FILE__) + "/../spec_helper"

describe ScenariosController do
  before(:each) do
    @user     = Factory.build(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    @user.role_code = User::ROLES[:instructor]
    @user.save
    @scenario = Factory(:scenario, :user => @user) 
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
        proc{ post :create, :scenario => Factory.attributes_for(:scenario, :name => "new scenario") }.should change(Scenario, :count).by(1)
      end
      
      it "should assign the current user as the Scenario user" do
        post :create, :scenario => Factory.attributes_for(:scenario)
        assigns(:scenario).user.should == @user
      end
  
      it "redirects to the created scenario" do
        post :create, :scenario => Factory.attributes_for(:scenario)
        response.should redirect_to(scenario_path(assigns(:scenario)))
      end
    end
  
    pending "Define invalid attrs for scenario"
    describe "with invalid params" do
    end
    
  end
  
  describe "PUT update" do
    
    before(:each) do
      @scenario = Factory(:scenario, :user => @user)
    end
    
    describe "with valid params" do      
      it "updates the requested scenario" do
        put :update, :id => @scenario.id, :scenario => { :name => "Inst var" }
        @scenario.reload.name.should == "Inst var"
      end
      
      it "redirects to the scenario" do
        put :update, :id => @scenario.id, :scenario => { :name => "Inst var" }
        response.should redirect_to(scenario_path(@scenario.id))
      end
    end
    
    pending "Define invalid attrs for Instructor system var"
    describe "with invalid params" do  
    end
  end
  
  
  describe "DELETE destroy" do
    before(:each) do
      @scenario = Factory(:scenario, :user => @user)
    end
    
    it "destroys the requested scenario" do
      proc { delete :destroy, :id => @scenario.id }.should change(Scenario, :count).by(-1)
    end
  
    it "redirects to the scenarios list" do
      delete :destroy, :id => @scenario.id
      response.should redirect_to(scenarios_path)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @user.role_code = User::ROLES[:student]
      @user.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions do
        response.should redirect_to(default_path_for(@user))
        flash[:notice].should == "You don't have the privileges to access this page"
      end
    end
  end
end
