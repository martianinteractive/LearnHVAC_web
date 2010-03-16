require File.dirname(__FILE__) + "/../spec_helper"

describe GlobalSystemVariablesController do

  before(:each) do
    @admin = Factory(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    login_as(@admin)
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
  
end
