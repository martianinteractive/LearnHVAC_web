require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::ScenarioVariablesController do
  before(:each) do
    institution         = Factory(:institution)
    manager             = Factory(:manager, :institution => institution)
    instructor          = Factory(:instructor, :institution => institution)
    master_scenario     = Factory(:master_scenario, :user => Factory(:admin))
    @scenario           = Factory(:scenario, :user => instructor, :master_scenario => master_scenario)
    @scenario_variable  = Factory(:scenario_variable, :scenario => @scenario)
    login_as(manager)
  end
  
  describe "GET index" do
    it "" do    
      get :index, :scenario_id => @scenario.id
      response.should render_template(:index)
    end
  end
  
  
  describe "GET show" do
    it "" do
      get :show, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should render_template(:show)
      assigns(:scenario_variable).should eq(@scenario_variable)
    end
  end
  
end
