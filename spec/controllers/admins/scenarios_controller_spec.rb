require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::ScenariosController do
  before(:each) do
    admins_login #makes @admin available
    @instructor      = user_with_role(:instructor)
    @master_scenario = Factory(:master_scenario, :user => @admin)
    @scenario        = Factory(:scenario, :user => @instructor, :master_scenario => @master_scenario)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:scenarios).should_not be_empty
    end
  end
  
  describe "GET list" do
    it "" do
      get :list
      response.should render_template(:list)
      assigns(:scenarios).should be_nil
    end
    
    it "" do
      get :list, :user_id => @instructor.id
      response.should render_template(:list)
      assigns(:scenarios).should_not be_empty
      assigns(:scenarios).should eq([@scenario])
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :id => @scenario.id
      response.should render_template(:show)
      assigns(:scenario).should eq(@scenario)
    end
  end
  
  describe "GET observers" do
    before(:each) do
      @group = Factory(:group, :instructor => @instructor, :scenario_ids => [@scenario.id])
    end
    
    it "" do
      get :observers, :id => @scenario.id
      response.should render_template(:observers)
    end
    
    it "" do
      get :observers, :id => @scenario.id
      assigns(:scenario).should eq(@scenario)
      assigns(:scenario).groups.should_not be_empty
      assigns(:scenario).groups.first.should eq(@group)
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
      before(:each) { @valid_params = Factory.attributes_for(:scenario, :name => "new scenario", :user_id => @instructor.id, :master_scenario_id => @master_scenario.id) }
      
      it "should change the Scenario count" do
        proc { post :create, :scenario => @valid_params }.should change(Scenario, :count).by(1)
      end
      
      it "should assign the selected user as the Scenario user" do
        post :create, :scenario => @valid_params
        assigns(:scenario).user.should == @instructor
      end
  
      it "redirects to the created admins_scenario" do
        post :create, :scenario => @valid_params
        response.should redirect_to(admins_scenario_path(assigns(:scenario)))
      end
    end
  
    describe "with invalid params" do
      it "" do
        proc { post :create, :scenario => { :user_id => @instructor.id } }.should_not change(Scenario, :count)
      end
      
      it "" do
        post :create, :scenario => { :user_id => @instructor.id }
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do 
    describe "with valid params" do      
      it "updates the requested scenario" do
        put :update, :id => @scenario.id, :scenario => { :name => "new scenario", :user_id => @instructor.id }
        @scenario.reload.name.should == "new scenario"
      end
      
      it "should update the scenario.user" do
        put :update, :id => @scenario.id, :scenario => { :name => "new scenario", :user_id => @admin.id }
        assigns(:scenario).user.should == @admin
      end
      
      it "redirects to the admins_scenario" do
        put :update, :id => @scenario.id, :scenario => { :name => "new scenairo", :user_id => @instructor.id }
        response.should redirect_to(admins_scenario_path(@scenario ))
      end
    end
    
    describe "with invalid params" do
      it "" do
        proc { put :update, :id => @scenario.id, :scenario => { :name => "", :user_id => @instructor.id } }.should_not change(Scenario, :count)
      end
      
      it "" do
        put :update, :id => @scenario.id, :scenario => { :name => "", :user_id => @instructor.id }
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
      response.should redirect_to(admins_scenarios_path)
    end
  end
  
  describe "Authorization" do
    before(:each) do
      user_logout
      @instructor.role_code = User::ROLES[:instructor]
      @instructor.save
      login_as(@instructor)
    end
    
    it "should require an admin user for all actions" do
      authorize_actions(:id => @scenario.id) do
        response.should redirect_to(default_path_for(@instructor))
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
  
end
