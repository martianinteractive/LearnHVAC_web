require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::ScenariosController do
  let(:current_user) { Factory.stub(:manager) }

  before(:each) do
    controller.stub(:current_user).and_return(current_user)
  end

  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, {:name => "bla"}.merge(stubs))
  end

  describe "GET index" do
    it "should expose scenarios and render the template" do
      current_user.stub_chain(:institution, :scenarios, :paginate).with(:page => nil, :per_page => 25).and_return([mock_scenario])
      get :index
      response.should render_template(:index)
      assigns[:scenarios].should eq([mock_scenario])
    end
  end
  
  describe "GET show" do
    it "should expose the scenario and render the template" do
      current_user.stub_chain(:institution, :scenarios, :find).with('37').and_return(mock_scenario)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns[:scenario].should eq(mock_scenario)
    end
  end
  
  describe "GET list" do
    it "should expose the scenarios and render the template" do
      current_user.stub_chain(:institution, :users, :instructor, :find, :created_scenarios).and_return([mock_scenario])
      get :list, :user_id => '1'
      response.should render_template(:list)
      assigns[:scenarios].should eq([mock_scenario])
    end
  end
  
end

