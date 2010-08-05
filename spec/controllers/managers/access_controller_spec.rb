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
  
  describe "GET :index" do
    it "" do
      group = Factory(:group, :creator => @instructor, :scenario_ids => [@scenario.id])
      get :index, :scenario_id => @scenario.id
      response.should render_template(:index)
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
      response.should redirect_to([:managers, @scenario, :accesses])
    end
  end
  
  describe "DELETE :destroy" do
    before(:each) do
      @membership = Factory(:individual_membership, :member => @manager, :scenario => @scenario)
    end
    
    it "" do
      proc { delete :destroy, :id => @membership.id, :scenario_id => @scenario.id }.should change(IndividualMembership, :count).by(-1)
    end
    
    it "" do
      delete :destroy, :id => @membership.id, :scenario_id => @scenario
      response.should redirect_to([:managers, @scenario, :accesses])
    end
    
    
    it "should not destroy an admin membership" do
      admin_membership = Factory(:individual_membership, :member => Factory(:admin), :scenario => @scenario)
      proc { delete :destroy, :id => admin_membership.id, :scenario_id => @scenario.id }.should raise_error      
    end
  end  
end
