require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::StudentsController do
  before(:each) do
    @instructor = Factory(:instructor)
    @student    = Factory(:student)
    @group      = Factory(:group, :name => "Class 01", :instructor => @instructor)
    @membership = Factory(:membership, :group => @group, :student => @student)
    login_as(@instructor)
  end
  
  describe "GET show" do
    it "" do
      get :show, :class_id => @group.id, :id => @student.id
      response.should render_template(:show)
      assigns(:student).should eq(@student)
    end
  end
  
end
