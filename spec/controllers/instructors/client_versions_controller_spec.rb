require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::ClientVersionsController do
  before(:each) do
    @instructor     = user_with_role(:instructor)
    @client_version = Factory(:client_version)
    login_as(@instructor)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:client_versions).should_not be_empty
      assigns(:client_versions).should eq([@client_version])
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @instructor.role_code = User::ROLES[:student]
      @instructor.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions(:get => [:index]) do
        response.should be_redirect
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
  
end
