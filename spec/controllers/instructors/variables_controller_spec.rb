require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::VariablesController do
  
  let(:current_user) { Factory.stub(:instructor) }

  before do
    controller.stub(:current_user).and_return(current_user)
    current_user.stub_chain(:created_scenarios, :find).and_return(mock_scenario)
  end
  
  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, {:name => "bla"}.merge(stubs))
  end
  
  def mock_variable(stubs={})
    @mock_variable ||= mock_model(Variable, {:display_name => "bla"}.merge(stubs))
  end
  
  context "GET index" do
    before do
      current_user.stub_chain(:created_scenarios, :find).and_return(mock_scenario)
      mock_scenario.stub_chain(:variables, :filter, :paginate).and_return([mock_variable])
    end
    
    it "should render template" do
      get :index, :scenario_id => "1", :id => "37"
      response.should render_template(:index)
    end
    
    it "should expose scenario variables" do
      get :index, :scenario_id => "1", :id => "37"
      assigns[:scenario_variables_grid].should be_instance_of(Wice::WiceGrid)
      #assigns[:scenario_variables].should eq([mock_variable])
    end
  end
  
  context "GET new" do
    it "should init a variable and expose it" do
      ScenarioVariable.should_receive(:new).and_return(mock_variable)
      get :new, :scenario_id => "37"
      assigns[:scenario_variable].should eq(mock_variable)
    end
    
    it "should render the new template" do
      ScenarioVariable.stub(:new).and_return(mock_variable)
      get :new, :scenario_id => "37"
      response.should render_template(:new)
    end
  end
  
  context "GET show" do
    before { mock_scenario.stub_chain(:variables, :find).and_return(mock_variable) }
    
    it "should expose the variable" do  
      get :show, :scenario_id => "37", :id => "1"
      assigns[:scenario_variable].should eq(mock_variable)
    end
    
    it "should display the show template" do
      get :show, :scenario_id => "37", :id => "1"
      response.should render_template(:show)
    end
  end
  
  context "POST create" do
    
    context "successfully" do
      before do
        mock_variable(:save => true)
        mock_scenario.stub_chain(:variables, :build).with({"params" => "bla"}).and_return(mock_variable)
      end
      
      it "should init and expose a variable" do
        post :create, :scenario_id => "37", :scenario_variable => {:params => "bla"}
        assigns[:scenario_variable].should eq(mock_variable)
      end 
      
      it "should redirect" do
        post :create, :scenario_id => "37", :scenario_variable => {:params => "bla"}
        response.should redirect_to(instructors_scenario_variable_path(assigns[:scenario], assigns[:scenario_variable]))
      end
    end
    
    context "unsuccessfully" do
      before do
        mock_variable(:save => false)
        mock_scenario.stub_chain(:variables, :build).with({"params" => "bla"}).and_return(mock_variable)
      end
      
      it "should init and expose a variable" do
        post :create, :scenario_id => "37", :scenario_variable => {:params => "bla"}
        assigns[:scenario_variable].should eq(mock_variable)
      end
      
      it "should render new template" do
        post :create, :scenario_id => "37", :scenario_variable => {:params => "bla"}
        response.should render_template(:new)
      end
    end
  end

  context "PUT update" do
    context "successfully" do
      before do
        mock_variable.stub(:update_attributes).and_return(true)
        mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
      end
      
      it "should expose the scenario variable" do
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
        assigns[:scenario_variable].should eq(mock_variable)
      end
      
      it "should redirect" do
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
        instructors_scenario_variable_path(assigns[:scenario], assigns[:scenario_variable])
      end
    end
    
    context "unssuccessfully" do
      before do
        mock_variable.stub(:update_attributes).and_return(false)
        mock_scenario.stub_chain(:variables, :find).and_return(mock_variable)
      end
      
      it "should expose the scenario variable" do
        put :update, :scenario_id => "37", :id => "1", :scenario_variable => {}
        assigns[:scenario_variable].should eq(mock_variable)
      end
      
      it "should render the edit template" do
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
      delete :destroy, :scenario_id => mock_scenario.id, :id => "1"
      response.should redirect_to(instructors_scenario_variables_path(assigns[:scenario]))
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
