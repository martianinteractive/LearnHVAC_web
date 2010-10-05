require File.dirname(__FILE__) + "/../spec_helper"

describe AccountsController do
  render_views
  
  describe "GET :new" do
    it "should assign as @account" do
      get :new
      response.should render_template(:new)      
      assigns(:account).should be_instance_of(User)
    end
  end
  
  describe "POST :create" do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end
    
    describe "a valid account" do
      it "should save an non-active account" do
        post :create, :user => Factory.attributes_for(:user)
        assigns(:account).active?.should_not be(true)
      end
      
      it "should save set the role as :instructor" do
        post :create, :user => Factory.attributes_for(:user)
        assigns(:account).role_code.should == User::ROLES[:instructor]
      end
      
      it "should send an activation information mail" do
        proc { post :create, :user => Factory.attributes_for(:user) }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
      
      it "should redirect instructors to the login action" do
        post :create, :user => Factory.attributes_for(:user)
        response.should redirect_to(login_path)
      end
      
      it "should redirect guests to guests/dashboard" do
        post :create, :user => Factory.attributes_for(:user).merge({:role_code => User::ROLES[:guest]})
        response.should redirect_to(guests_dashboard_path(:token => assigns(:account).perishable_token))
      end
      
    end
    
    describe "an invalid account" do
      it "" do
        post :create, :user => {}
        response.should render_template(:new)
      end
      
      it "due to an invalid role_code" do
        post :create, :user => Factory.attributes_for(:user).merge({:role_code => User::ROLES[:admin]})
        response.should render_template(:new)
      end
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @user = Factory(:admin)
      login_as @user
    end
    
    it "should require NO user" do
      authorize_actions({}, {:get => [:new], :post => [:create]}) do
        response.should be_redirect
        flash[:notice].should == "You must be logged out to access this page"
      end
    end
  end
  
end
