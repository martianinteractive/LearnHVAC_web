require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::AccessController do
  let(:current_user) { Factory.stub(:manager) }

  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, {:name => ""}.merge(stubs))
  end

  def mock_membership(stubs={})
    @mock_membership ||= mock_model(Membership, stubs)
  end

  before do
    controller.stub(:current_user).and_return(current_user)
    current_user.stub_chain(:institution, :scenarios, :find).and_return(mock_scenario)
  end

  context "GET index" do
    it "should expose memberships" do
      mock_scenario.stub_chain(:memberships, :includes, :paginate).and_return([mock_membership])
      get :index, :scenario_id => "37"
      assigns[:memberships].should eq([mock_membership])
    end

    it "should render the index template" do
      mock_scenario.stub_chain(:memberships, :includes, :paginate).and_return([mock_membership])
      get :index, :scenario_id => "37"
      response.should render_template(:index)
    end
  end

  context "POST create" do
    context "sucessfully" do
      it "should expose new individual membership" do
        mock_scenario.stub_chain(:individual_memberships, :new).and_return(mock_membership)
        mock_membership.should_receive(:save).and_return(true)
        post :create, :scenario_id => "37"
        assigns[:individual_membership].should eq(mock_membership)
      end

      it "should redirect" do
        mock_scenario.stub_chain(:individual_memberships, :new).and_return(mock_membership)
        mock_membership.stub(:save).and_return(true)
        post :create, :scenario_id => "37"
        response.should redirect_to([:managers, assigns[:scenario], :accesses])
      end
    end

    context "unsuccessfully" do
      it "" do
        mock_scenario.stub_chain(:individual_memberships, :new).and_return(mock_membership)
        mock_membership.should_receive(:save).and_return(false)
        post :create, :scenario_id => "37"
        assigns[:individual_membership].should eq(mock_membership)
      end

      it "" do
        mock_scenario.stub_chain(:individual_memberships, :new).and_return(mock_membership)
        mock_membership.stub(:save).and_return(true)
        post :create, :scenario_id => "37"
        response.should redirect_to([:managers, assigns[:scenario], :accesses])
      end
    end

    context "DELETE destroy" do
      it "should expose membership" do
        mock_scenario.stub_chain(:memberships, :non_admin, :find).and_return(mock_membership)
        mock_membership.should_receive(:destroy).and_return(true)
        delete :destroy, :scenario_id => "37", :id => "1"
        assigns[:membership].should eq(mock_membership)
      end

      it "should redirect" do
        mock_scenario.stub_chain(:memberships, :non_admin, :find).and_return(mock_membership)
        mock_membership.stub(:destroy).and_return(true)
        delete :destroy, :scenario_id => "37", :id => "1"
        response.should redirect_to([:managers, assigns[:scenario], :accesses])
      end
    end
  end
end
