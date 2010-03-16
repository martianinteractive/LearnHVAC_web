require 'spec_helper'

describe ScenarioSystemVariablesController do

  def mock_scenario_system_variable(stubs={})
    @mock_scenario_system_variable ||= mock_model(ScenarioSystemVariable, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all scenario_system_variables as @scenario_system_variables" do
      ScenarioSystemVariable.stub(:all) { [mock_scenario_system_variable] }
      get :index
      assigns(:scenario_system_variables).should eq([mock_scenario_system_variable])
    end
  end

  describe "GET show" do
    it "assigns the requested scenario_system_variable as @scenario_system_variable" do
      ScenarioSystemVariable.stub(:find).with("37") { mock_scenario_system_variable }
      get :show, :id => "37"
      assigns(:scenario_system_variable).should be(mock_scenario_system_variable)
    end
  end

  describe "GET new" do
    it "assigns a new scenario_system_variable as @scenario_system_variable" do
      ScenarioSystemVariable.stub(:new) { mock_scenario_system_variable }
      get :new
      assigns(:scenario_system_variable).should be(mock_scenario_system_variable)
    end
  end

  describe "GET edit" do
    it "assigns the requested scenario_system_variable as @scenario_system_variable" do
      ScenarioSystemVariable.stub(:find).with("37") { mock_scenario_system_variable }
      get :edit, :id => "37"
      assigns(:scenario_system_variable).should be(mock_scenario_system_variable)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created scenario_system_variable as @scenario_system_variable" do
        ScenarioSystemVariable.stub(:new).with({'these' => 'params'}) { mock_scenario_system_variable(:save => true) }
        post :create, :scenario_system_variable => {'these' => 'params'}
        assigns(:scenario_system_variable).should be(mock_scenario_system_variable)
      end

      it "redirects to the created scenario_system_variable" do
        ScenarioSystemVariable.stub(:new) { mock_scenario_system_variable(:save => true) }
        post :create, :scenario_system_variable => {}
        response.should redirect_to(scenario_system_variable_url(mock_scenario_system_variable))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved scenario_system_variable as @scenario_system_variable" do
        ScenarioSystemVariable.stub(:new).with({'these' => 'params'}) { mock_scenario_system_variable(:save => false) }
        post :create, :scenario_system_variable => {'these' => 'params'}
        assigns(:scenario_system_variable).should be(mock_scenario_system_variable)
      end

      it "re-renders the 'new' template" do
        ScenarioSystemVariable.stub(:new) { mock_scenario_system_variable(:save => false) }
        post :create, :scenario_system_variable => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested scenario_system_variable" do
        ScenarioSystemVariable.should_receive(:find).with("37") { mock_scenario_system_variable }
        mock_scenario_system_variable.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :scenario_system_variable => {'these' => 'params'}
      end

      it "assigns the requested scenario_system_variable as @scenario_system_variable" do
        ScenarioSystemVariable.stub(:find) { mock_scenario_system_variable(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:scenario_system_variable).should be(mock_scenario_system_variable)
      end

      it "redirects to the scenario_system_variable" do
        ScenarioSystemVariable.stub(:find) { mock_scenario_system_variable(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(scenario_system_variable_url(mock_scenario_system_variable))
      end
    end

    describe "with invalid params" do
      it "assigns the scenario_system_variable as @scenario_system_variable" do
        ScenarioSystemVariable.stub(:find) { mock_scenario_system_variable(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:scenario_system_variable).should be(mock_scenario_system_variable)
      end

      it "re-renders the 'edit' template" do
        ScenarioSystemVariable.stub(:find) { mock_scenario_system_variable(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested scenario_system_variable" do
      ScenarioSystemVariable.should_receive(:find).with("37") { mock_scenario_system_variable }
      mock_scenario_system_variable.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the scenario_system_variables list" do
      ScenarioSystemVariable.stub(:find) { mock_scenario_system_variable(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(scenario_system_variables_url)
    end
  end

end
