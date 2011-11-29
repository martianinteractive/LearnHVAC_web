require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::ScenariosController do
  let(:current_user) { Factory.stub(:instructor) }

  before do
    controller.stub(:current_user).and_return(current_user)
    Scenario.stub(:find).and_return(mock_scenario(:user => current_user, :shared? => nil))
  end

  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, {:name => ""}.merge(stubs))
  end

  describe "GET index" do
    it "should expose scenarios" do
      current_user.stub_chain(:created_scenarios, :paginate).and_return([mock_scenario])
      get :index
      assigns[:scenarios].should eq([mock_scenario])
    end

    it "should render index" do
      current_user.stub_chain(:created_scenarios, :paginate).and_return([mock_scenario])
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    it "should exponse scenario" do
      get :show, :id => '37'
      assigns[:scenario].should eq(mock_scenario)
    end

    it "should render show" do
      get :show, :id => '37'
      response.should render_template(:show)
    end

    it "should redirect to the scenarios view if the requested scenario isn't owned by the current user" do
      chuck     = Factory(:admin)
      scenario  = Factory(:valid_scenario, :user => chuck)
      Scenario.stub(:find).and_return(scenario)
      get :show, :id => scenario.id
      response.should redirect_to(instructors_scenarios_path)
      flash[:warning].should eq('You are not allowed to access to that scenario.')
    end

    it "should render show if the requested scenario is a shared scenario" do
      chuck     = Factory(:admin)
      scenario  = Factory(:valid_scenario, :user => chuck, :shared => true)
      get :show, :id => scenario.id
      response.code.should eq("200")
      response.should render_template(:show)
    end
  end

  describe "GET new" do
    it "should init and expose scenario" do
      Scenario.should_receive(:new).and_return(mock_scenario)
      get :new
      assigns[:scenario].should eq(mock_scenario)
    end

    it "should render the new template" do
      Scenario.stub(:new).and_return(mock_scenario)
      get :new
      response.should render_template(:new)
    end
  end

  describe "GET edit" do
    it "should expose scenario" do
      get :edit, :id => "37"
      assigns[:scenario].should eq(mock_scenario)
    end

    it "should render the edit template" do
      get :edit, :id => "37"
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do

    describe "successfully" do
      before { mock_scenario.stub(:update_attributes).and_return(true) }

      it "should expose scenario" do
        put :update, :id => "37", :scenario => {}
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should redirect" do
        put :update, :id => "37", :scenario => {}
        response.should redirect_to(instructors_scenario_path(assigns[:scenario]))
      end

    end

    describe "unssuccessfully" do
      before { mock_scenario.stub(:update_attributes).and_return(false) }

      it "should render edit template" do
        put :update, :id => "37", :scenario => {}
        response.should render_template(:edit)
      end

      it "should expose scenario" do
        put :update, :id => "37", :scenario => {}
        assigns[:scenario].should eq(mock_scenario)
      end
    end
  end

  describe "DELETE destroy" do

    it "should delete" do
      mock_scenario.should_receive(:destroy).and_return(true)
      delete :destroy, :id => "37"
    end

    it "should expose scenario" do
      delete :destroy, :id => "37"
      assigns[:scenario].should eq(mock_scenario)
    end

    it "should redirect" do
      delete :destroy, :id => "37"
      response.should redirect_to(instructors_scenarios_url)
    end
  end
end
