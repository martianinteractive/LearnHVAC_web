require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::AccessController do
  render_views
  
  before(:each) do
    institution       = Factory(:institution)
    @instructor       = Factory(:instructor, :institution => institution)
    master_scenario   = Factory(:master_scenario, :user => @instructor)
    @scenario         = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario)
    @manager          = Factory(:manager, :institution => institution)
    login_as @manager
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
      proc { post :create, :scenario_id => @scenario.id }.should change(IndividualMembership, :count).by(1)
    end
    
    it "" do
      post :create, :scenario_id => @scenario.id
      redirect_to [:managers, @scenario, :access]
    end
  end
  
  describe "DELETE :destroy" do
    it "" do
      Factory(:individual_membership, :member => @manager, :scenario => @scenario)
      proc { delete :destroy, :scenario_id => @scenario.id, :member_id => @manager.id }.should change(IndividualMembership, :count).by(-1)
    end
  end
  
end
