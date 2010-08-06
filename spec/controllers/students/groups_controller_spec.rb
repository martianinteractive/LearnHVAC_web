require File.dirname(__FILE__) + "/../../spec_helper"

describe Students::GroupsController do
  render_views
  
  before(:each) do
    @student    = Factory(:student)
    @instructor = Factory(:instructor)
    scenario    = Factory(:scenario, :user => @instructor, :master_scenario => Factory(:master_scenario, :user => Factory(:admin)))
    @group      = Factory(:group, :name => "Class 01", :creator => @instructor, :scenario_ids => [scenario.id])
    @membership = Factory(:group_membership, :group => @group, :member => @student, :scenario => Factory.stub(:scenario))
    login_as(@student)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
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
      user_logout
    end
    
    it "should require a student for all actions" do
      authorize_actions({:id => @group.id}, {:get => [:index, :show]}) do
        response.should redirect_to(login_path)
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
  
end
