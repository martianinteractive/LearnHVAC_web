require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::PublicScenariosController do
  before(:each) do
    institution       = Factory(:institution)
    instructor        = Factory(:instructor, :institution => institution)
    master_scenario   = Factory(:master_scenario, :user => instructor)
    @scenario         = Factory(:scenario, :user => instructor, :master_scenario => master_scenario)
    @manager          = Factory(:manager, :institution => institution)
    login_as @manager
  end
  
  describe "POST :create" do
    it "" do
      proc { post :create, :scenario_id => @scenario.id}.should change(UserScenario, :count).by(1)
    end
    
    it "" do
      post :create, :scenario_id => @scenario.id
      redirect_to [:access, :instructors, assigns(:user_scenario)]
    end
  end
  
  describe "invalid POST :create" do
    
    it "" do
    end
    
  end
end
