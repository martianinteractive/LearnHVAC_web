require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::StudentsController do
  before(:each) do
    admin_login
    @student      = user_with_role(:student)
    @group        = Factory.build(:group, :name => "Class 01", :instructor => @admin)
    @group.group_scenarios.build(:scenario_id => "1")
    @group.save
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
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
end
