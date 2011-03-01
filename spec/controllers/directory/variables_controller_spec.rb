require File.dirname(__FILE__) + "/../../spec_helper"

describe Directory::VariablesController do
  let(:current_user) { Factory.stub(:instructor) }
  let(:mock_institution) { mock_model(Institution) }
  let(:mock_scenario) { mock_model(Scenario) }
  let(:mock_variable) { mock_model(Variable) }

  before { controller.stub(:current_user).and_return(current_user) }

  describe "GET index" do
    before do
      Institution.stub(:find).and_return(mock_institution)
      mock_institution.stub_chain(:scenarios, :public, :find).and_return(mock_scenario)
      mock_scenario.stub_chain(:variables, :order, :paginate).and_return([mock_variable])
    end

    it "should find the institution" do
      Institution.should_receive(:find).with('1').and_return(mock_institution)
      get :index, :institution_id => '1', :scenario_id => '1'
    end

    it "should expose scenario" do
      get :index, :institution_id => '1', :scenario_id => '1'
      assigns[:scenario].should eq(mock_scenario)
    end

    it "should expose variables" do
      get :index, :institution_id => '1', :scenario_id => '1'
      assigns[:variables].should eq([mock_variable])
    end

    it "should render index" do
      get :index, :institution_id => '1', :scenario_id => '1'
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    before do
      Institution.stub(:find).and_return(mock_institution)
      mock_institution.stub_chain(:scenarios, :public, :find).and_return(mock_scenario)
      mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
    end

    it "should expose variable" do
      get :show, :institution_id => "1", :scenario_id => "1", :id => "1"
      assigns[:variable].should eq(mock_variable)
    end

    it "should render show template" do
      get :show, :institution_id => "1", :scenario_id => "1", :id => "1"
      response.should render_template(:show)
    end

  end
end
