require 'spec_helper'

describe Instructors::SharedScenariosController do

  let(:current_user)  { Factory(:instructor) }
  let(:scenario)      { Factory(:valid_scenario, :user => current_user) }

  before { controller.stub!(:current_user).and_return(current_user) }

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

    it "creates a new cloned scenario" do
      @fancy_instructor = Factory(:instructor)
      @fancy_scenario   = Factory(:valid_scenario, :user => @fancy_instructor)
      expect {
        get :clone, :shared_scenario_id => @fancy_scenario.id
      }.to change(current_user.created_scenarios, :count).by(1)
    end

    it "redirects to the shared scenarios index" do
      get :clone, :shared_scenario_id => scenario.id
      response.should redirect_to(instructors_shared_scenarios_path)
    end

    it "shows an error message when the current user tries to clone one of his own scenarios" do
      @awesome_scenario = Factory(:valid_scenario, :user => current_user)
      @awesome_scenario.master_scenario = Factory(:valid_master_scenario)
      @awesome_scenario.save
      get :clone, :shared_scenario_id => @awesome_scenario.id
      flash[:error].should eq("Scenario could not be clonned.")
    end

    it "shows an error message when the clonning scenario has no master scenario" do
      @fancy_instructor = Factory(:instructor)
      @fancy_scenario   = Factory(:valid_scenario, :user => @fancy_instructor)
      @fancy_scenario.master_scenario = nil
      @fancy_scenario.save
      get :clone, :shared_scenario_id => @fancy_scenario.id
      flash[:error].should eq("Scenario could not be clonned.")
    end


  end

end
