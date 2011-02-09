require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::MasterScenariosController do
  let(:master_scenario) { mock_model(MasterScenario, :name => 'bla') }
  let(:current_user) { Factory.stub(:admin) }
  
  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
  end
  
  describe "GET index" do
    it "should expose master_scenarios and render the template" do
      MasterScenario.should_receive(:paginate).and_return([master_scenario])
      get :index
      response.should render_template(:index)
      assigns[:master_scenarios].should eq([master_scenario])
    end
  end
  
  describe "GET show" do
    it "should expose master_scenario and render the show template" do
      MasterScenario.should_receive(:find).with('37').and_return(master_scenario)
      get :show, :id => '37'
      response.should render_template(:show)
      assigns[:master_scenario].should eq(master_scenario)
    end
  end
  
  describe "GET new" do
    it "should expose a new instance of master_scenario and render the new template" do
      MasterScenario.should_receive(:new).and_return(master_scenario)
      get :new
      assigns[:master_scenario].should eq(master_scenario)
      response.should render_template(:new)
    end
  end
  
  describe "GET edit" do
    it "should expose the master_scenario and render the edit template" do
      MasterScenario.should_receive(:find).with('37').and_return(master_scenario)
      get :edit, :id => '37'
      assigns[:master_scenario].should eq(master_scenario)
      response.should render_template(:edit)
    end
  end
  
  describe "GET clone" do
    it "should clone a master scenario" do
      MasterScenario.should_receive(:find).with('37').and_return(master_scenario)
      master_scenario.should_receive(:clone!).and_return(mock_model(MasterScenario, :valid? => true))
      get :clone, :id => '37'
    end
  end
  
  describe "POST create" do
    let(:master_scenario) {mock_model(MasterScenario, :save => true, :user= => current_user) }
    
    describe "with valid attrs" do
      it "should expose the master scenario" do
        MasterScenario.should_receive(:new).with('these' => 'params').and_return(master_scenario)
        master_scenario.should_receive(:save).and_return(:true)
        post :create, :master_scenario => {:these => 'params'}
        assigns[:master_scenario].should eq(master_scenario)
      end
      
      it "should redirect to the master scenario" do
        MasterScenario.stub!(:new).and_return(master_scenario)
        post :create, :master_scenario => {}
        response.should redirect_to(admins_master_scenario_url(assigns[:master_scenario]))
      end
    end
    
    describe "with invalid attrs" do
      let(:master_scenario) { mock_model(MasterScenario, :save => false) }
      
      it "should expose the master scenario" do
        MasterScenario.should_receive(:new).with('these' => 'params').and_return(master_scenario)
        master_scenario.should_receive(:save).and_return(:false)
        master_scenario.should_receive(:user=).and_return(current_user)
        post :create, :master_scenario => {:these => 'params'}
        assigns[:master_scenario].should eq(master_scenario)
      end
      
      it "should redirect to the master scenario" do
        MasterScenario.stub!(:new).and_return(master_scenario)
        master_scenario.stub!(:user=)
        post :create, :master_scenario => {}
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do
    let(:master_scenario) { mock_model(MasterScenario, :update_attributes => true) }
    
    describe "with valid params" do
      it "should expose the master scenario" do
        MasterScenario.should_receive(:find).with('37').and_return(master_scenario)
        master_scenario.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :master_scenario => {:these => 'params'}
        assigns[:master_scenario].should eq(master_scenario)
      end    
      
      it "should redirect to master scenario" do
        MasterScenario.stub!(:find).and_return(master_scenario)
        put :update, :id => '37'
        response.should redirect_to(admins_master_scenario_url(assigns[:master_scenario]))
      end
    end
    
    describe "with invalid params" do
      let(:master_scenario) { mock_model(MasterScenario, :update_attributes => false) }
      
      it "should expose the master scenario" do
        MasterScenario.should_receive(:find).with('37').and_return(master_scenario)
        master_scenario.should_receive(:update_attributes).with({'these' => 'params'})
        master_scenario.stub!(:name)
        put :update, :id => '37', :master_scenario => {:these => 'params'}
        assigns[:master_scenario].should eq(master_scenario)
      end    
      
      it "should redirect to master scenario" do
        MasterScenario.stub!(:find).and_return(master_scenario)
        master_scenario.stub!(:name)
        put :update, :id => '37'
        response.should render_template(:edit)
      end
    end
  end
  
  describe "DELETE destroy" do
    let(:master_scenario) { mock_model(Institution, :destroy => true) }
    
    it "should destroy the master scenario" do
      MasterScenario.should_receive(:find).with('37').and_return(master_scenario)
      master_scenario.should_receive(:destroy).and_return(true)
      delete :destroy, :id => '37'
    end
    
    it "should redirect to index" do
      MasterScenario.stub!(:find).and_return(master_scenario)
      delete :destroy, :id => '37'
      response.should redirect_to(admins_master_scenarios_url)
    end
  end
end
