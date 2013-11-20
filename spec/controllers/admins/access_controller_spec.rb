require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::AccessController do
  let(:membership) { mock_model(Membership) }
  let(:scenario) { mock_model(Scenario, :name => 'bla') }
  let(:current_user) { Factory.stub(:admin) }
  
  before(:each) do
    controller.stub(:current_user).and_return(current_user)
  end
  
  context "responding to GET index" do
    before(:each) do
      scenario.stub_chain(:memberships, :includes, :paginate).and_return([membership])
    end
    
    it "should expose all permissions for a given @scenario" do
      Scenario.should_receive(:find).with('30').and_return(scenario)
      get :index, :scenario_id => '30'
      assigns[:memberships].should eq([membership])
    end
    
    it "should render the index template" do
      Scenario.stub(:find).with('30').and_return(scenario)
      get :index, :scenario_id => '30'
      response.should render_template('index')
    end
  end
  
  context "Post: create" do
    let(:individual_membership) { mock_model(IndividualMembership, :save => true) }
    
    before(:each) do
      Scenario.stub(:find).with('30').and_return(scenario)
      individual_membership.stub_chain('scenario.name')
    end
    
    context "with valid params" do
      it "should expose an newly created individual membership" do
        IndividualMembership.should_receive(:new).with(:member => current_user, :scenario => scenario).and_return(individual_membership)
        post :create, :scenario_id => '30'
        assigns[:individual_membership].should eq(individual_membership)
      end
      
      it "should redirect with successful notice" do
        IndividualMembership.stub(:new).with(:member => current_user, :scenario => scenario).and_return(individual_membership)
        post :create, :scenario_id => '30'
        response.should redirect_to admins_scenario_accesses_path(scenario)
        flash[:notice].should include('You can now download')
      end
    end
    
    context "with invalid params" do
      let(:individual_membership) { mock_model(IndividualMembership, :save => false) }
      
      before(:each) do
        Scenario.stub(:find).with('30').and_return(scenario)
        individual_membership.stub_chain('scenario.name')
      end
      
      it "should expose a newly created individual membership" do
        IndividualMembership.should_receive(:new).with(:member => current_user, :scenario => scenario).and_return(individual_membership)
        post :create, :scenario_id => '30'
        assigns[:individual_membership].should eq(individual_membership)
      end
      
      it "should redirect with an error message" do
        IndividualMembership.stub(:new).with(:member => current_user, :scenario => scenario).and_return(individual_membership)
        post :create, :scenario_id => '30'
        response.should redirect_to admins_scenario_accesses_path(scenario)
        flash[:notice].should include('There were problems')
      end
    end
    
    context "responding to DELETE destroy" do
      let(:membership) { mock_model(Membership, :destroy => true) }
      
      it "should delete" do
        Membership.should_receive(:find).with("37").and_return(membership)
        membership.should_receive(:destroy)
        delete :destroy, :scenario_id => '30', :id => "37"
      end
    end
  end

end
