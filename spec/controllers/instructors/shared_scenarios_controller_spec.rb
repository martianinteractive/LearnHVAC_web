require 'spec_helper'

describe Instructors::SharedScenariosController do

  let(:scenario) { Factory(:valid_scenario) }

  describe "GET 'index'" do

    it "returns http success" do
      get :index
      response.should be_success
    end

    it 'renders the right template' do
      get :index
      response.should render_template(:index)
    end

    it 'assigns @scenarios' do
      3.times { Factory(:valid_scenario, :shared => true) }
      scenarios = Scenario.shared
      get :index
      assigns(:scenarios).should eq(scenarios)
    end

  end

  describe "GET 'clone'" do

    it "redirects to the shared scenarios index" do
      pending "Not yet implemented"
      get :clone, :shared_scenario_id => scenario.id
      response.should redirect_to(instructors_shared_scenarios_path)
    end

    it "creates a new cloned scenario" do
      pending "Not yet implemented"
      expect {
        get :clone, :shared_scenario_id => scenario.id
      }.to change(Scenario, :count).by(1)
    end

  end

end
