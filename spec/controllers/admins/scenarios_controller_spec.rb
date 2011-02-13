require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::ScenariosController do
  let(:current_user) { Factory.stub(:admin) }

  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
  end

  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, stubs)
  end

  describe "GET index" do
    it "should expose scenarios and render the template" do
      Scenario.should_receive(:paginate).and_return([mock_scenario])
      get :index
      response.should render_template(:index)
      assigns[:scenarios].should eq([mock_scenario])
    end
  end

  describe "GET list" do
    it "should exponse scenarios for a given user" do
      mock_user = mock_model(User, :created_scenarios => [mock_scenario])
      User.should_receive(:find).with('1').and_return(mock_user)
      get :list, :user_id => '1'
      assigns[:scenarios].should eq([mock_scenario])
    end

    it "should render the list template" do
      mock_user = mock_model(User, :created_scenarios => [mock_scenario])
      User.stub(:find).and_return(mock_user)
      get :list, :user_id => '1'
      response.should render_template(:list)
    end
  end

  describe "GET show" do
    it "should expose scenario and render the show template" do
      Scenario.should_receive(:find).with('37').and_return(mock_scenario({:name => 'bla'}))
      get :show, :id => '37'
      response.should render_template(:show)
      assigns[:scenario].should eq(mock_scenario)
    end
  end

  describe "GET new" do
    it "should expose a new instance of scenario and render the new template" do
      Scenario.should_receive(:new).and_return(mock_scenario)
      get :new
      assigns[:scenario].should eq(mock_scenario)
      response.should render_template(:new)
    end
  end

  describe "GET edit" do
    it "should expose the scenario and render the edit template" do
      Scenario.should_receive(:find).with('37').and_return(mock_scenario({:name => 'bla'}))
      get :edit, :id => '37'
      assigns[:scenario].should eq(mock_scenario)
      response.should render_template(:edit)
    end
  end

  describe "POST create" do
    describe "with valid attrs" do
      it "should expose the master scenario" do
        Scenario.should_receive(:new).with('these' => 'params').and_return(mock_scenario({:save => true}))
        mock_scenario.should_receive(:save).and_return(:true)
        post :create, :scenario => {:these => 'params'}
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should redirect to the master scenario" do
        Scenario.stub!(:new).and_return(mock_scenario({:user= => current_user, :save => true}))
        post :create, :scenario => {}
        response.should redirect_to(admins_scenario_url(assigns[:scenario]))
      end
    end

    describe "with invalid attrs" do
      it "should expose the scenario" do
        Scenario.should_receive(:new).with('these' => 'params').and_return(mock_scenario({:save => false}))
        mock_scenario.should_receive(:save).and_return(:false)
        post :create, :scenario => {:these => 'params'}
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should redirect to the scenario" do
        Scenario.stub!(:new).and_return(mock_scenario({:save => false}))
        post :create, :scenario => {}
        response.should render_template(:new)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should expose the scenario" do
        Scenario.should_receive(:find).with('37').and_return(mock_scenario({:update_attributes => true}))
        mock_scenario.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :scenario => {:these => 'params'}
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should redirect to scenario" do
        Scenario.stub!(:find).and_return(mock_scenario({:update_attributes => true}))
        put :update, :id => '37'
        response.should redirect_to(admins_scenario_url(assigns[:scenario]))
      end
    end

    describe "with invalid params" do
      it "should expose the scenario" do
        Scenario.should_receive(:find).with('37').and_return(mock_scenario({:update_attributes => false, :name => 'bla'}))
        mock_scenario.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :scenario => {:these => 'params'}
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should redirect to scenario" do
        Scenario.stub!(:find).and_return(mock_scenario({:name => 'bla', :update_attributes => false}))
        put :update, :id => '37'
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "should destroy the scenario" do
      Scenario.should_receive(:find).with('37').and_return(mock_scenario({:destroy => true}))
      mock_scenario.should_receive(:destroy).and_return(true)
      delete :destroy, :id => '37'
    end

    it "should redirect to index" do
      Scenario.stub!(:find).and_return(mock_scenario)
      delete :destroy, :id => '37'
      response.should redirect_to(admins_scenarios_url)
    end
  end
end
