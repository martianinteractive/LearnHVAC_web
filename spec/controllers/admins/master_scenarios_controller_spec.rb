require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::MasterScenariosController do
  before(:each) do
    admins_login
    @master_scenario = Factory(:master_scenario, :user => @admin)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:master_scenarios).should_not be_empty
    end
  end
  
  describe "GET tag" do
    it "" do
      get :tag, :tag => @master_scenario.tags.first
      response.should render_template(:tag)
      assigns(:master_scenarios).should_not be_empty
    end
    
    it "" do
      get :tag, :tag => "faketag"
      response.should render_template(:tag)
      assigns(:master_scenarios).should be_empty
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :id => @master_scenario.id
      response.should render_template(:show)
      assigns(:master_scenario).should eq(@master_scenario)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:master_scenario).should be_instance_of(MasterScenario)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :id => @master_scenario.id
      response.should render_template(:edit)
      assigns(:master_scenario).should eq(@master_scenario)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      before(:each) { @valid_params = Factory.attributes_for(:master_scenario, :name => "new scenario", :desktop_id => @master_scenario.client_version.id) }
      
      it "should change the MasterScenario count" do
        proc{ post :create, :master_scenario => @valid_params }.should change(MasterScenario, :count).by(1)
      end
      
      it "should assign the current admin as the master_scenario creator" do
        post :create, :master_scenario => @valid_params
        assigns(:master_scenario).user.should == @admin
      end
      
      it "redirects to the created admins_master_scenario" do
        post :create, :master_scenario => @valid_params
        response.should redirect_to(admins_master_scenario_path(assigns(:master_scenario)))
      end
    end
  
    describe "with invalid params" do
      it "" do
        proc { post :create, :master_scenario => {} }.should_not change(MasterScenario, :count)
      end
      
      it "" do
        post :create, :master_scenario => {}
        response.should render_template(:new)
      end
    end
  end
  
  describe "POST clone" do
    it "" do
      proc { post :clone, :id => @master_scenario.id }.should change(MasterScenario, :count).by(1)
    end
    
    it "" do
      post :clone, :id => @master_scenario.id
      response.should redirect_to(admins_master_scenarios_path)
    end
  end
  
  describe "PUT update" do 
    describe "with valid params" do      
      it "updates the requested scenario" do
        put :update, :id => @master_scenario.id, :master_scenario => { :name => "new scenario" }
        @master_scenario.reload.name.should == "new scenario"
      end
      
      it "redirects to the master_scenario" do
        put :update, :id => @master_scenario.id, :master_scenario => { :name => "new scenairo" }
        response.should redirect_to(admins_master_scenario_path(@master_scenario))
      end
    end
    
    describe "with invalid params" do
      it "" do
        put :update, :id => @master_scenario.id, :master_scenario => { :name => "" }
        response.should render_template(:edit)
      end
    end
  end
  
  describe "DELETE destroy" do
    it "destroys the requested scenario" do
      proc { delete :destroy, :id => @master_scenario.id }.should change(MasterScenario, :count).by(-1)
    end

    it "redirects to the master_scenarios list" do
      delete :destroy, :id => @master_scenario.id
      response.should redirect_to(admins_master_scenarios_path)
    end
  end
  
  describe "Authorization" do
    before(:each) do
      @admin.role_code = User::ROLES[:instructor]
      @admin.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions(:id => @master_scenario.id) do
        response.should redirect_to(default_path_for(@admin))
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
end
