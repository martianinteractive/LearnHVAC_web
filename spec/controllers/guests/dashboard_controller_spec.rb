require File.dirname(__FILE__) + "/../../spec_helper"

describe Guests::DashboardController do
  before(:each) do
    @client_version = Factory(:client_version)
    @guest          = Factory(:guest)
    login_as(@guest)
  end
  
  describe "GET :show" do
    it "should show the client versions" do
      get :show
      response.should render_template(:show)
      assigns(:client_versions).should_not be_empty
    end
  end
end
