require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::AccessController do
  let(:current_user) { Factory.stub(:instructor) }
  let(:mock_membership) { mock_model(Membership) }
  let(:mock_scenario) { mock_model(Scenario, {:name => ""}) }
  
  before { controller.stub(:current_user).and_return(current_user) }
  
  describe "GET index" do
    before do
      current_user.stub_chain(:created_scenarios, :find).and_return(mock_scenario)
      mock_scenario.stub_chain(:memberships, :includes, :paginate).and_return([mock_membership])
    end
    
    it "should expose memberships" do
      get :index, :scenario_id => "37"
      assigns[:memberships].should eq([mock_membership])
    end
    
    it "should render index" do
      get :index, :scenario_id => "37"
      response.should render_template(:index)
    end
  end
  
  describe "DELETE destroy" do
    before do
      current_user.stub_chain(:created_scenarios, :find).and_return(mock_scenario)
      mock_scenario.stub_chain(:group_memberships, :find).and_return(mock_membership)
    end
    
    it "should expose the membership" do
      delete :destroy, :id => "1", :scenario_id => "37"
      assigns[:membership].should eq(mock_membership)
    end
    
    it "should delete" do
      mock_membership.should_receive(:destroy).and_return(true)
      delete :destroy, :id => "1", :scenario_id => "37"
    end
    
    it "should redirect" do
      delete :destroy, :id => "1", :scenario_id => "37"
      response.should redirect_to([:instructors, assigns[:scenario], :accesses])
    end
  end
end
