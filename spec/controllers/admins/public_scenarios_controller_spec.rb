require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::PublicScenariosController do
  before(:each) do
    @admin            = Factory(:admin)
    instructor        = Factory(:instructor)
    master_scenario   = Factory(:master_scenario, :user => @admin)
    @scenario         = Factory(:scenario, :user => instructor, :master_scenario => master_scenario)
    login_as @admin
  end
  
  describe "POST :create" do
    it "" do
      proc { post :create, :scenario_id => @scenario.id}.should change(UserScenario, :count).by(1)
    end
    
    it "" do
      post :create, :scenario_id => @scenario.id
      response.should redirect_to([:access, :admins, @scenario])
    end
  end
  
end
