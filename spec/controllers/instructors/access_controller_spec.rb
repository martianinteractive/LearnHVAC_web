require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::AccessController do
  render_views
  before(:each) do
    @instructor       = Factory(:instructor)
    @admin            = Factory(:admin)
    master_scenario   = Factory(:master_scenario, :user => @admin)
    @scenario         = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario)
    @group            = Factory(:group, :creator => @instructor, :scenario_ids => [@scenario.id])
    @user_scenario    = Factory(:user_scenario, :user => @admin, :scenario => @scenario)
    login_as @instructor
  end
  
  describe "GET :show" do
    it "should description" do
      get :show, :scenario_id => @scenario.id
      response.should render_template(:show)
      assigns(:scenario).should == @scenario
      assigns(:scenario).groups.should_not be_empty
      assigns(:scenario).groups.first.should == @group
      assigns(:scenario).users.last.should == @admin
    end
  end

end
