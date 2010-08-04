require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::StudentsController do
  before(:each) do
    @instructor = Factory(:instructor)
    @student    = Factory(:student)
    @group      = Factory(:group, :name => "Class 01", :creator => @instructor)
    scenario    = Factory.stub(:scenario)
    
    Factory(:group_scenario, :group => @group, :scenario => scenario)
    Factory(:group_membership, :group => @group, :scenario => scenario, :member => @student)
    
    login_as(@instructor)
  end
  
  describe "GET show" do
    it "" do
      get :show, :id => @student.id, :class_id => @group.id
      response.should render_template(:show)
      assigns(:student).should eq(@student)
    end
  end
  
end
