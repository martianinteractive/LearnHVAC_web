require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::StudentsController do
  before(:each) do
    @instructor = user_with_role(:instructor)
    @student    = user_with_role(:student)
    @group      = Factory.build(:group, :name => "Class 01", :instructor => @instructor)
    @group.expects(:scenario_validator).returns(true)
    @group.save
    @membership = Factory(:membership, :group => @group, :student => @student)
    login_as(@instructor)
  end
  
  describe "GET show" do
    it "" do
      get :show, :group_id => @group.id, :id => @student.id
      response.should render_template(:show)
      assigns(:student).should_not be_nil
      assigns(:student).should eq(@student)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      user_logout
    end
    
    it "should require an instructor for all actions" do
      authorize_actions({:get => [:show]}) do
        response.should redirect_to(login_path)
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
  
end
