require File.dirname(__FILE__) + "/../spec_helper"

describe UserSessionsController do
  
  describe "create session with disabled user" do
    before(:each) do
      user = Factory(:user, :role_code => 4, :enabled => false)
      post :create, :user_session => { :login => user.login, :password => user.password }
    end
    
    it { assigns(:user_session).should_not be_valid }
    it { response.should render_template(:new) }
  end
  
  describe "create session with enabled user" do
    before(:each) do
      user = Factory(:user, :role_code => 4, :enabled => true)
      controller.stubs(:default_path).returns("/")
      post :create, :user_session => { :login => user.login, :password => user.password }
    end
    
    it { assigns(:user_session).should be_valid }
    it { response.should redirect_to("/") }
  end

end
