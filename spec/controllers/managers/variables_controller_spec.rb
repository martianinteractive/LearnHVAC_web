require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::VariablesController do
  let(:current_user) { Factory.stub(:manager) }
  
  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
    current_user.stub_chain(:institution, :scenarios, :find).with("37").and_return(mock_scenario)
  end
  
  def mock_variable(stubs={})
    @mock_variable ||= mock_model(Variable, stubs)
  end
  
  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, {:name => "bla"}.merge(stubs))
  end
  
  describe "GET index" do
    it "should render the index template" do
      mock_scenario.stub_chain(:variables, :order, :paginate).and_return([mock_variable])
      get :index, :scenario_id => "37"
      response.should render_template(:index)
    end
    
    it "should expose the scenario variables" do
      mock_scenario.stub_chain(:variables, :order, :paginate).and_return([mock_variable])
      get :index, :scenario_id => "37"
      assigns[:scenario_variables].should eq([mock_variable])
    end
  end
  
  describe "GET show" do
    it "should expose the variables" do
      mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
      get :show, :scenario_id => "37", :id => "1"
      assigns[:scenario_variable].should eq(mock_variable)
    end
    
    it "should render the show template" do
      mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
      get :show, :scenario_id => "37", :id => "1"
      response.should render_template(:show)
    end
  end
end
