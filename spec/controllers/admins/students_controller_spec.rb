require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::StudentsController do
  before(:each) do
    @admin        = Factory(:admin)
    @student      = Factory(:student)
    @group        = Factory.build(:group, :name => "Class 01", :instructor => @admin)
    @membership   = Factory(:membership, :group => @group, :student => @student)
    login_as(@admin)
  end
  
  describe "GET index" do
    it "" do
      get :index, :class_id => @group.id
      response.should render_template(:index)
      assigns(:students).should_not be_empty
    end
  end

end
