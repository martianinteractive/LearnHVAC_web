require File.dirname(__FILE__) + "/../spec_helper"

describe UserSessionsController do
  
  before(:each) do
    @user = user_with_role(:admin)
  end
  
  describe "POST :create" do
    
    it "should not authenticate disabled users" do
      @user.enabled = false
      @user.save
      post :create, :user_session => { :login => @user.login, :password => @user.password }
      response.should render_template(:new)
      response.body.should match(/You have been temporary disabled/)
    end
    
    it "should authenticate valid and enabled users" do
      @user_session = mock('user_session')
      @user_session.stubs(:user).returns(@user)
      @user_session.stubs(:record).returns(@user)
      @user_session.stubs(:destroy)
      UserSession.stubs(:find).returns(@user_session)
      post :create, :user_session => { :login => @user.login, :password => @user.password }
      response.should redirect_to(default_path_for(@user))
    end
    
  end

end
