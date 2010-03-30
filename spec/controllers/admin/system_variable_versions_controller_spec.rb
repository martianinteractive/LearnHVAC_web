require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::SystemVariableVersionsController do
  before(:each) do
    admin_login
    @master_scenario = Factory(:master_scenario, :user => @admin)
    # Version 2
    @system_variable = Factory(:system_variable, :name => "Water Temp", :master_scenario => @master_scenario)
    @system_variable.update_attributes(:name => "Air Temp") # Version 3
    @system_variable.update_attributes(:name => "Env Temp") # Version 4
  end
  
  pending "Fix :index with controller stubbing when available"
  describe "GET index" do
    it "" do
    end
  end
  
  describe "GET show" do    
    it "" do
      get :show, :master_scenario_id => @master_scenario.id, :master_version_id => "2", :id => @system_variable.id
      response.should render_template(:show)
      assigns(:system_variable_version).should_not be_nil
      assigns(:system_variable_version).name.should == "Water Temp"
    end
    
    it "" do
      get :show, :master_scenario_id => @master_scenario.id, :master_version_id => "3", :id => @system_variable.id
      response.should render_template(:show)
      assigns(:system_variable_version).should_not be_nil
      assigns(:system_variable_version).name.should == "Air Temp"
    end
  end

end
