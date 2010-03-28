require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::MasterScenariosController do
  before(:each) do
    admin_login
    @master_scenario = Factory(:master_scenario, :user => @admin)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:master_scenarios).should_not be_empty
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
      it "should change the MasterScenario count" do
        proc{ post :create, :master_scenario => Factory.attributes_for(:master_scenario, :name => "new scenario") }.should change(MasterScenario, :count).by(1)
      end
      
      it "should assign the current admin as the master_scenario creator" do
        post :create, :master_scenario => { :name => "new master scenario" }
        assigns(:master_scenario).user.should == @admin
      end
      
      it "redirects to the created admin_master_scenario" do
        post :create, :master_scenario => Factory.attributes_for(:master_scenario, :name => "new scenario")
        response.should redirect_to(admin_master_scenario_path(assigns(:master_scenario)))
      end
    end
  
    pending "Define invalid attrs for master_scenario"
    describe "with invalid params" do
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
        response.should redirect_to(admin_master_scenario_path(@master_scenario))
      end
    end
    
    pending "Define invalid attrs for Instructor system var"
    describe "with invalid params" do  
    end
  end
  
    
  describe "DELETE destroy" do
    it "destroys the requested scenario" do
      proc { delete :destroy, :id => @master_scenario.id }.should change(MasterScenario, :count).by(-1)
    end

    it "redirects to the master_scenarios list" do
      delete :destroy, :id => @master_scenario.id
      response.should redirect_to(admin_master_scenarios_path)
    end
  end
  
  
  describe "Authorization" do
    before(:each) do
      @admin.role_code = User::ROLES[:instructor]
      @admin.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions do
        response.should redirect_to(default_path_for(@admin))
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end

end
