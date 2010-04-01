require File.dirname(__FILE__) + "/../../spec_helper"

describe Students::GroupsController do
  before(:each) do
    @student    = user_with_role(:student)
    @group      = Factory.build(:group, :name => "Class 01", :instructor => user_with_role(:instructor))
    @group.group_scenarios.build(:scenario_id => "1")
    @group.save
    @membership = Factory(:membership, :group => @group, :student => @student)
    login_as(@student)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:groups).should_not be_empty
      assigns(:groups).should eq([@group])
    end
  end

  describe "GET show" do
    it "" do
      get :show, :id => @group.id
      response.should render_template(:show)
      assigns(:group).should eq(@group)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @student.role_code = User::ROLES[:instructor]
      @student.save
    end
    
    it "should require a student for all actions" do
      authorize_actions({:get => [:index, :show]}) do
        response.should redirect_to(default_path_for(@student))
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
  
end
