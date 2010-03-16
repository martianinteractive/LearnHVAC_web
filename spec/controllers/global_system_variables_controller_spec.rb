require File.dirname(__FILE__) + "/../spec_helper"

describe GlobalSystemVariablesController do

  before(:each) do
    @admin = Factory.build(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    @admin.role_code = User::ROLES[:superadmin]
    @admin.save
    login_as(@admin)
  end
  
  describe "GET index" do
    it "" do
      GlobalSystemVariable.expects(:all).returns([mock_global_var])
      get :index
      response.should render_template(:index)
      assigns(:global_system_variables).should eq([mock_global_var])
    end
  end
  
  describe "GET show" do
    it "" do
      GlobalSystemVariable.expects(:find).with("37").returns(mock_global_var)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:global_system_variable).should be(mock_global_var)
    end
  end
  
  describe "Authorization" do
    it "should require an authenticated superadmin for all actions" do
      @admin.role_code = User::ROLES[:student]
      @admin.save
      authorize_actions do
        response.should redirect_to(users_path)
        flash[:notice].should == "You don't have the privileges to access this page"
      end
    end
  end
  
  
  def mock_global_var(attrs = {})
    @mock_global_variable ||= Factory(:global_system_variable, attrs)
  end
  
end
