require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::SystemVariableVersionsController do
  # before(:each) do
  #   admins_login
  #   @master_scenario = Factory(:master_scenario, :user => @admin)
  #   # Version 2
  #   @system_variable = Factory(:system_variable, :name => "Water Temp", :master_scenario => @master_scenario)
  #   @system_variable.update_attributes(:name => "Air Temp") # Version 3
  #   @system_variable.update_attributes(:name => "Env Temp") # Version 4
  # end
  # 
  # describe "GET index" do
  #   it "" do
  #     get :index, :master_scenario_id => @master_scenario.id, :revision_id => "2"
  #     response.should render_template(:index)
  #   end
  # end
  # 
  # describe "GET show" do    
  #   it "" do
  #     get :show, :master_scenario_id => @master_scenario.id, :revision_id => "2", :id => @system_variable.id
  #     response.should render_template(:show)
  #     assigns(:system_variable_version).should_not be_nil
  #     assigns(:system_variable_version).name.should == "Water Temp"
  #   end
  #   
  #   it "" do
  #     get :show, :master_scenario_id => @master_scenario.id, :revision_id => "3", :id => @system_variable.id
  #     response.should render_template(:show)
  #     assigns(:system_variable_version).should_not be_nil
  #     assigns(:system_variable_version).name.should == "Air Temp"
  #   end
  # end

end
