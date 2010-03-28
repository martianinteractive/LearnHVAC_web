require File.dirname(__FILE__) + "/../spec_helper"

describe StudentsController do
  before(:each) do
    @instructor = user_with_role(:instructor)
    @student    = user_with_role(:student)
    @group      = Factory(:group, :name => "Class 01", :instructor => @instructor)
    @membership = Factory(:membership, :group => @group, :student => @student)
    login_as(@instructor)
  end
  
  describe "GET index" do
    it "" do
      get :index, :group_id => @group.id
      response.should render_template(:index)
      assigns(:students).should_not be_empty
      assigns(:students).should eq([@student])
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @instructor.role_code = User::ROLES[:student]
      @instructor.save
    end
    
    it "should require an instructor for all actions" do
      authorize_actions({:get => [:index]}) do
        response.should redirect_to(default_path_for(@instructor))
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
  
end
