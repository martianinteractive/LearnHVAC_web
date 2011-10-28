require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::SystemVariablesController do

  let(:current_user) { Factory.stub(:admin) }

  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
  end

  def mock_system_variable(stubs={})
    @mock_system_variable ||= mock_model(SystemVariable, stubs)
  end

  def mock_master_scenario(stubs={})
    @mock_master_scenario ||= mock_model(MasterScenario, {:name => 'bla', :variables => []}.merge(stubs))
  end

  describe "GET index" do
    it "should expose the master scenario's system variables" do
      MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
      get :index, :master_scenario_id => '37'
      assigns[:system_variables].should_not be_nil
    end

    it "should render the index template" do
      mock_master_scenario.stub_chain(:variables, :filter, :paginate).and_return([mock_system_variable])
      MasterScenario.stub!(:find).and_return(mock_master_scenario)
      get :index, :master_scenario_id => '37'
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    it "should expose the system variable" do
      mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable)
      MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
      get :show, :master_scenario_id => '37', :id => '1'
      assigns[:system_variable].should eq(mock_system_variable)
    end

    it "should expose the master scenario" do
      mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable)
      MasterScenario.stub!(:find).with('37').and_return(mock_master_scenario)
      get :show, :master_scenario_id => '37', :id => '1'
      assigns[:master_scenario].should eq(mock_master_scenario)
    end

    it "should render the show template" do
      mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable)
      MasterScenario.stub(:find).and_return(mock_master_scenario)
      get :show, :master_scenario_id => '37', :id => '1'
      response.should render_template(:show)
    end
  end

  describe "GET new" do
    it "should create an instance of system variable" do
      MasterScenario.stub(:find).and_return(mock_master_scenario)
      SystemVariable.should_receive(:new).and_return(mock_system_variable)
      get :new, :master_scenario_id => '37'
      assigns[:system_variable].should eq(mock_system_variable)
    end
  end

  describe "GET edit" do
    it "should expose the system variable" do
      mock_system_variable.stub!(:name)
      mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable)
      MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
      get :edit, :master_scenario_id => '37', :id => '1'
      assigns[:system_variable].should eq(mock_system_variable)
    end

    it "should expose the master scenario" do
      mock_system_variable.stub!(:name)
      mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable)
      MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
      get :edit, :master_scenario_id => '37', :id => '1'
      assigns[:master_scenario].should eq(mock_master_scenario)
    end
  end

  describe "POST create" do
    describe "with valid attrs" do
      it "should find the master scenario and initialize and system variable" do
        MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
        SystemVariable.should_receive(:new).with('these' => 'params').and_return(mock_system_variable({:save => true}))
        mock_system_variable.should_receive(:master_scenario=).and_return(mock_master_scenario)
        mock_system_variable.should_receive(:save).and_return(:true)
        post :create, :master_scenario_id => '37', :system_variable => {:these => 'params'}
      end

      it "should expose the system variable" do
        MasterScenario.stub(:find).and_return(mock_master_scenario)
        SystemVariable.stub(:new).and_return(mock_system_variable({:save => true, :master_scenario= => mock_master_scenario}))
        post :create, :master_scenario_id => '37', :system_variable => {:these => 'params'}
        assigns[:system_variable].should eq(mock_system_variable)
      end

      it "should expose the master scenario" do
        MasterScenario.stub(:find).and_return(mock_master_scenario)
        SystemVariable.stub(:new).and_return(mock_system_variable({:save => true, :master_scenario= => mock_master_scenario}))
        post :create, :master_scenario_id => '37', :system_variable => {:these => 'params'}
        assigns[:master_scenario].should eq(mock_master_scenario)
      end

      it "should redirect to the master scenario" do
        MasterScenario.stub(:find).and_return(mock_master_scenario)
        SystemVariable.stub(:new).and_return(mock_system_variable({:save => true, :master_scenario= => mock_master_scenario}))
        post :create, :master_scenario_id => '37', :system_variable => {}
        response.should redirect_to(admins_master_scenario_system_variable_path(assigns[:master_scenario], assigns[:system_variable]))
      end
    end

    describe "with invalid attrs" do
      it "should find the master scenario and initialize and system variable" do
        MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
        SystemVariable.should_receive(:new).with('these' => 'params').and_return(mock_system_variable({:save => false}))
        mock_system_variable.should_receive(:master_scenario=).and_return(mock_master_scenario)
        mock_system_variable.should_receive(:save).and_return(false)
        post :create, :master_scenario_id => '37', :system_variable => {:these => 'params'}
      end

      it "should expose the system variable" do
        MasterScenario.stub(:find).and_return(mock_master_scenario)
        SystemVariable.stub(:new).and_return(mock_system_variable({:save => false, :master_scenario= => mock_master_scenario}))
        post :create, :master_scenario_id => '37', :system_variable => {:these => 'params'}
        assigns[:system_variable].should eq(mock_system_variable)
      end

      it "should expose the master scenario" do
        MasterScenario.stub(:find).and_return(mock_master_scenario)
        SystemVariable.stub(:new).and_return(mock_system_variable({:save => false, :master_scenario= => mock_master_scenario}))
        post :create, :master_scenario_id => '37', :system_variable => {:these => 'params'}
        assigns[:master_scenario].should eq(mock_master_scenario)
      end

      it "should redirect to the master scenario" do
        MasterScenario.stub(:find).and_return(mock_master_scenario)
        SystemVariable.stub(:new).and_return(mock_system_variable({:save => false, :master_scenario= => mock_master_scenario}))
        post :create, :master_scenario_id => '37', :system_variable => {}
        response.should render_template(:new)
      end
    end
  end

  describe "PUT update" do
    describe "with valid attributes" do
      it "should expose the system variable" do
        MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
        mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable({:update_attributes => true}))
        put :update, :master_scenario_id => '37', :id => '1'
        assigns[:system_variable].should eq(mock_system_variable)
      end

      it "should redirect to the updated system variable" do
        MasterScenario.stub!(:find).and_return(mock_master_scenario)
        mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable({:update_attributes => true}))
        put :update, :master_scenario_id => '37', :id => '1'
        response.should redirect_to(admins_master_scenario_system_variable_path(assigns[:master_scenario], assigns[:system_variable]))
      end
    end

    describe "with invalid attributes" do
      it "should expose the system variable" do
        MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
        mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable({:update_attributes => false}))
        put :update, :master_scenario_id => '37', :id => '1'
        assigns[:system_variable].should eq(mock_system_variable)
      end

      it "should redirect to the updated system variable" do
        MasterScenario.stub!(:find).and_return(mock_master_scenario)
        mock_master_scenario.stub_chain(:variables, :find).and_return(mock_system_variable({:update_attributes => false}))
        put :update, :master_scenario_id => '37', :id => '1'
        response.should render_template(:edit)
      end
    end

    describe "GET update status" do
      it "should expose system variables" do
        MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
        mock_master_scenario.stub_chain(:variables, :find).and_return([mock_system_variable({:update_attribute => true})])
        post :update_status, :master_scenario_id => '37', :variable_ids => ['1'], :format => :js
        assigns[:system_variables].should eq([mock_system_variable])
      end

      it "should render js" do
        MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
        mock_master_scenario.stub_chain(:variables, :find).and_return([mock_system_variable({:update_attribute => true})])
        post :update_status, :master_scenario_id => '37', :variable_ids => ['1'], :format => :js
        response.content_type.should eq('text/javascript')
      end
    end

    describe "DELETE destroy" do
      it "should delete the system var" do
        MasterScenario.should_receive(:find).with('37').and_return(mock_master_scenario)
        SystemVariable.should_receive(:find).with('1').and_return(mock_system_variable({:destroy => true}))
        mock_system_variable.should_receive(:destroy).and_return('bla')
        delete :destroy, :master_scenario_id => '37', :id => '1'
      end

      it "should redirect back" do
        MasterScenario.stub!(:find).and_return(mock_master_scenario)
        SystemVariable.stub!(:find).and_return(mock_system_variable)
        delete :destroy, :master_scenario_id => '37', :id => '1'
        response.should redirect_to(admins_master_scenario_system_variables_path(assigns[:master_scenario], assigns[:system_variable]))
      end
    end

  end

end
