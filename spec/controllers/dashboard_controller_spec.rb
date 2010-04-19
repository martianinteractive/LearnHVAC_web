require 'spec_helper'

describe DashboardController do
  
  describe "GET index" do
    it "should redirect to login screen when no current_user" do
      get :index
      response.should redirect_to(login_path)
    end
    
    it "should raise argument error when role is nil" do
      @user = Factory(:user, :login => "joedoe", :email => "jdoe@lhvac.com", :role_code => nil)
      login_as(@user)
      lambda {get :index}.should raise_error(ArgumentError)
    end
    
    it "should raise argument error when role is nil" do
      @user = Factory(:user, :login => "joedoe", :email => "jdoe@lhvac.com", :role_code => 0)
      login_as(@user)
      get :index
      response.should redirect_to(guests_dashboard_path)
    end
  end
  
end
