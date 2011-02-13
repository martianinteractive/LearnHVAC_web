require File.dirname(__FILE__) + "/../../spec_helper"

describe Guests::DashboardController do
  before(:each) do
    @client_version = Factory(:client_version)
    @guest          = Factory(:guest)
  end
  
  describe "GET :show" do
    it "" do
      login_as(@guest)
      get :show
      response.should render_template(:show)
      assigns(:client_versions).should_not be_empty
    end
    
    it "should allow authorization via perishable token" do
      get :show, :token => @guest.perishable_token
      response.should render_template(:show)
      assigns(:client_versions).should_not be_empty
    end
    
    it "should not allow authorization for an invalid perishable token" do
      student = Factory(:student)
      get :show, :token => student.perishable_token
      response.should redirect_to(login_path)
    end
  end
end
