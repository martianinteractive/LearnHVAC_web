require File.dirname(__FILE__) + "/../../spec_helper"

describe Students::AccountsController do
  before(:each) do
    @instructor = Factory(:instructor)
    @admin      = Factory(:admin)
    scenario    = Factory(:scenario, :user => @instructor, :master_scenario => Factory(:master_scenario, :user => @admin))
    @group      = Factory(:group, :name => "Class 01", :creator => @instructor, :scenario_ids => [scenario.id])
  end
  
  describe "GET :new" do
    it "should assign as @account" do
      get :new, :code => @group.code
      response.should render_template(:new)      
      assigns(:account).should be_instance_of(User)
      assigns(:account).should be_instance_of(User)
    end
  end
  
  describe "POST :create" do
    before(:each) do
      ms            = Factory(:master_scenario, :user => @admin)
      @scenario_1   = Factory(:scenario, :master_scenario => ms, :name => 'scenario 1', :user => @instructor)
      @scenario_2   = Factory(:scenario, :master_scenario => ms, :name => 'scenario 2', :user => @instructor)

      Factory(:group_scenario, :group => @group, :scenario => @scenario_1)
      Factory(:group_scenario, :group => @group, :scenario => @scenario_2)
      
      ActionMailer::Base.deliveries = []
    end
    
    describe "a valid account" do
      it "should save an not-active account" do
        post :create, :user => Factory.attributes_for(:user, :group_code => @group.code)
        assigns(:account).active?.should_not be(true)
      end
      
      # here we ensure the saved user is an student.
      it "should save set the role as :student" do
        post :create, :user => Factory.attributes_for(:user, :group_code => @group.code)
        assigns(:account).role_code.should == User::ROLES[:student]
      end
      
      it "should send an activation information mail" do
        proc { post :create, :user => Factory.attributes_for(:user, :group_code => @group.code) }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
      
      it "should redirect to the login action" do
        post :create, :user => Factory.attributes_for(:user, :group_code => @group.code)
        flash[:notice].should match(/Your account has been created/)
        response.should redirect_to(login_path)
      end
      
      it "should create group_memberships if a valid group code is given" do
        proc { post :create, :code => @group.code, :user => Factory.attributes_for(:user, :group_code => @group.code) }.should change(GroupMembership, :count).by(3)
      end
      
      it "should assign the user to the group" do
        post :create, :code => @group.code, :user => Factory.attributes_for(:user, :group_code => @group.code)
        assigns(:account).groups.should eq([@group])
      end
      
    end
    
    describe "an invalid account" do
      it "" do
        post :create
        response.should render_template(:new)
      end
    end
  end
  
  describe "Authentication" do
    before(:each) do
      login_as @admin
    end
    
    it "should require NO user" do
      authorize_actions({}, {:get => [:new], :post => [:create]}) do
        response.should be_redirect
        flash[:notice].should == "You must be logged out to access this page"
      end
    end
  end
end
