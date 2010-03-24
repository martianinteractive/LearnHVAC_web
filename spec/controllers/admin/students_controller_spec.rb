require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::StudentsController do
  before(:each) do
    admin_login
    @student      = Factory(:user, :first_name => "student", :email => "student@mi.com", :login => "student")
    @group        = Factory(:group, :name => "Class 01", :instructor => @admin)
    @membership   = Factory(:membership, :group => @group, :student => @student)
  end
  
  describe "GET index" do
    it "" do
      get :index, :group_id => @group.id
      response.should render_template(:index)
      assigns(:students).should_not be_empty
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @admin.role_code = User::ROLES[:student]
      @admin.save
    end
    
    it "should require an admin for all actions" do
      authorize_actions({:get => [:index]}) do
        response.should redirect_to(default_path_for(@admin))
        flash[:notice].should == "You don't have the privileges to access this page"
      end
    end
  end
end
