require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::VariablesController do

  let(:current_user) { Factory.stub(:admin) }

  before do
    controller.stub!(:current_user).and_return(current_user)
    Scenario.stub!(:find).with('37').and_return(mock_scenario)
  end

  def mock_variable(stubs={})
    @mock_variable ||= mock_model(Variable, {:name => ""}.merge(stubs))
  end

  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, {:name => ""}.merge(stubs))
  end

  context "GET index" do
    before do
      mock_scenario.stub_chain(:variables, :filter, :paginate).and_return([mock_variable])
    end

    it "should expose variables" do
      get :index, :scenario_id => "37"
      assigns[:scenario_variables].should_not be_nil
    end

    it "should render index" do
      get :index, :scenario_id => "37"
      response.should render_template(:index)
    end
  end

  context "GET new" do
    before { ScenarioVariable.stub(:new).and_return(mock_variable) }

    it "should init new variable" do
      ScenarioVariable.should_receive(:new).and_return(mock_variable)
      get :new, :scenario_id => "37"
    end

    it "should expose new variable" do
      get :new, :scenario_id => "37"
      assigns[:scenario_variable].should eq(mock_variable)
    end

    it "should render new template" do
      get :new, :scenario_id => "37"
      response.should render_template(:new)
    end
  end

  context "GET edit" do
    before do
      mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
    end

    it "should expose scenario and scenario var" do
      get :edit, :scenario_id => "37", :id => "1"
      assigns[:scenario].should eq(mock_scenario)
      assigns[:scenario_variable].should eq(mock_variable)
    end

    it "should render the edit template" do
      get :edit, :scenario_id => "37", :id => "1"
      response.should render_template(:edit)
    end
  end

  context "POST create" do
    context "successfully" do
      before do
        mock_variable(:save => true)
        mock_scenario.stub_chain(:varible, :build).and_return(mock_variable)
      end

      it "should expose" do
        post :create, :scenario_id => "37"
        assigns[:scenario_variable].should eq(mock_variable)
      end

      it "should save the variable" do
        mock_variable.should_receive(:save).and_return(true)
        post :create, :scenario_id => "37"
      end

      it "should redirect" do
        post :create, :scenario_id => "37"
        response.should redirect_to(admins_scenario_variable_path(assigns[:scenario], assigns[:scenario_variable]))
      end
    end

    context "unsuccessfully" do
      before do
        mock_variable(:save => false)
        mock_scenario.stub_chain(:varible, :build).and_return(mock_variable)
      end

      it "should expose" do
        post :create, :scenario_id => "37"
        assigns[:scenario_variable].should eq(mock_variable)
      end

      it "should save the variable" do
        mock_variable.should_receive(:save).and_return(false)
        post :create, :scenario_id => "37"
      end

      it "should redirect" do
        post :create, :scenario_id => "37"
        response.should render_template(:new)
      end
    end
  end

  context "PUT update" do
    context "successfully" do
      before do
        mock_variable(:update_attributes => true)
        mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
      end

      it "should expose the variable" do
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
        assigns[:scenario_variable].should eq(mock_variable)
      end

      it "should update" do
        mock_variable.should_receive(:update_attributes).and_return(true)
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
      end

      it "should redirect" do
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
        response.should redirect_to(admins_scenario_variable_path(assigns[:scenario], assigns[:scenario_variable]))
      end
    end

    context "unsuccessfully" do
      before do
        mock_variable(:update_attributes => false)
        mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
      end

      it "should expose variable" do
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
        assigns[:scenario_variable].should eq(mock_variable)
      end

      it "should update" do
        mock_variable.should_receive(:update_attributes).and_return(false)
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
      end

      it "should render edit" do
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
        response.should render_template(:edit)
      end
    end
  end

  context "PUT update status" do
    before do
      mock_scenario.stub_chain(:variables, :find).and_return([mock_variable])
      mock_variable.stub(:update_attribute).and_return(true)
    end

    it "should expose scenario variables" do
      xhr(:put, :update_status, :scenario_id => "37", :variables_ids => ['1'])
      assigns[:variables].should eq([mock_variable])
    end

    it "should not render" do
      xhr(:put, :update_status, :scenario_id => "37", :variables_ids => ['1'])
      response.should render_template(:update_status)
    end
  end

  context "DELETE destroy" do
    before do
      mock_scenario.stub_chain(:variables, :find, :destroy).and_return(true)
    end

    it "should expose scenario" do
      delete :destroy, :scenario_id => "37", :id => "1"
      assigns[:scenario].should eq(mock_scenario)
    end

    it "should redirect" do
      delete :destroy, :scenario_id => "37", :id => "1"
      response.should redirect_to(admins_scenario_variables_path(assigns[:scenario]))
    end
  end

  context "DELETE drop" do
    before do
      mock_scenario.stub_chain(:variables, :where, :destroy_all).and_return(true)
    end

    it "should expose scenario" do
      xhr(:delete, :drop, :scenario_id => "37", :id => "1")
      assigns[:scenario].should eq(mock_scenario)
    end

    it "should render js template" do
      xhr(:delete, :drop, :scenario_id => "37", :id => "1")
      response.should render_template(:drop)
    end
  end
end
