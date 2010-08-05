require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::AccessController do
  render_views
  
  before(:each) do
    @admin            = Factory(:admin)
    @instructor       = Factory(:instructor)
    master_scenario   = Factory(:master_scenario, :user => @admin)
    @scenario         = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario)
    login_as @admin
  end
  
  describe "GET :show" do
    it "" do
      group = Factory(:group, :creator => @instructor, :scenario_ids => [@scenario.id])
      get :show, :scenario_id => @scenario.id
      response.should render_template(:show)
      assigns(:scenario).should == @scenario
      assigns(:scenario).groups.should_not be_empty
      assigns(:scenario).groups.first.should eq(group)
    end
  end
  
  describe "POST :create" do
    it "" do
      proc { post :create, :scenario_id => @scenario.id}.should change(IndividualMembership, :count).by(1)
    end
    
    it "" do
      post :create, :scenario_id => @scenario.id
      response.should redirect_to([:admins, @scenario, :access])
    end
  end
  
  describe "DELETE :destroy" do
    it "" do
      m = Factory(:individual_membership, :member => @admin, :scenario => @scenario)
      proc { delete :destroy, :id => m.id, :scenario_id => @scenario.id }.should change(IndividualMembership, :count).by(-1)
    end
  end
  
end
