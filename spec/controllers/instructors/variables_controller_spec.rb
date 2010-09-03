require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::VariablesController do

  before(:each) do
    @user                     = Factory(:instructor)
    @admin                    = Factory(:admin)
    @master_scenario          = Factory(:master_scenario, :user => @admin)
    @scenario                 = Factory(:scenario, :user => @user, :master_scenario => @master_scenario)
    @scenario_variable        = Factory(:scenario_variable, :scenario => @scenario)
    login_as(@user)
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
  
  describe "GET new" do
    it "" do
      get :new, :scenario_id => @scenario.id
      response.should render_template(:new)
      assigns(:scenario_variable).should be_instance_of(ScenarioVariable)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should render_template(:edit)
      assigns(:scenario_variable).should eq(@scenario_variable)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      
      it "should change the scenario.scenario_variables count" do
        proc do
          post :create, :scenario_id => @scenario.id, 
               :scenario_variable => Factory.attributes_for(:scenario_variable, :name => "new scen. sys var")
        end.should change(@scenario.variables, :size).by(+1)
      end
      
      it "redirects to the created scenario_variable" do
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable)
        response.should redirect_to(instructors_scenario_variable_path(@scenario, assigns(:scenario_variable)))
      end
    end
  
    describe "with invalid params (i.e. empty name)" do
      it "should not change the scenario variables size" do
        proc do
          post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable, :name => "")
        end.should_not change(@scenario.variables, :size)
      end
      
      it "shoud render the new template" do
        post :create, :scenario_id => @scenario.id, :scenario_variable => Factory.attributes_for(:scenario_variable, :name => "")
        response.should render_template(:new)
      end
    end
    
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "updated var name" }
        Scenario.find(@scenario.id).variables.first.name.should == "updated var name"
      end
      
      it "redirects to the scenario_variable" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "scenerio var" }
        response.should redirect_to(instructors_scenario_variable_path(@scenario, @scenario_variable))
      end
    end

    describe "with invalid params (i.e. empty name)" do  
      it "should render #edit with errors" do
        put :update, :scenario_id => @scenario.id, :id => @scenario_variable.id, :scenario_variable => { :name => "" }
        response.should render_template(:edit)
      end
    end
  end
  
  describe "put :update_status" do
    before(:each) do
      @scenario_variable.update_attribute(:disabled, false)
    end
    
    it "" do
      xhr(:put, :update_status, :scenario_id => @scenario.id, :variables_ids => [@scenario_variable.id])
      response.should render_template(:update_status)  
    end
    
    it "should mass disable scenario variables" do
      v1 = Factory(:scenario_variable, :disabled => false, :scenario => @scenario)
      v2 = Factory(:scenario_variable, :disabled => false, :scenario => @scenario)
      v3 = Factory(:scenario_variable, :disabled => false, :scenario => @scenario)
      ScenarioVariable.where(:disabled => false).should have(4).vars
      xhr(:put, :update_status, :scenario_id => @scenario.id, :variables_ids => [v1.id, v2.id, v3.id], :status => 'disable')
      ScenarioVariable.where(:disabled => false).should have(1).var
      [v1.reload, v2.reload, v3.reload].each { |v| v.should be_disabled }
    end
    
    it "should mass enable scenario variables" do
      v1 = Factory(:scenario_variable, :disabled => true, :scenario => @scenario)
      v2 = Factory(:scenario_variable, :disabled => true, :scenario => @scenario)
      ScenarioVariable.where(:disabled => true).should have(2).vars
      xhr(:put, :update_status, :scenario_id => @scenario.id, :variables_ids => [v1.id, v2.id])
      ScenarioVariable.where(:disabled => true).should have(0).vars
      [v1.reload, v2.reload].each { |v| v.should_not be_disabled }
    end
  end
  
  describe "DELETE destroy" do    
    it "destroys the requested scenario_variable" do      
      proc do
        delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      end.should change(@scenario.variables, :count).by(-1)
    end
  
    it "redirects to the scenario_variables list" do
      delete :destroy, :scenario_id => @scenario.id, :id => @scenario_variable.id
      response.should redirect_to(instructors_scenario_variables_path(@scenario))
    end
  end
  
  describe "DELETE drop" do
    it "should mass delete vars" do
      v1 = Factory(:scenario_variable, :scenario => @scenario)
      proc { 
        xhr(:delete, :drop, :scenario_id => @scenario.id, :variables_ids => [@scenario_variable.id, v1.id]) 
      }.should change(ScenarioVariable, :count).by(-2)
    end
    
    it "" do
      xhr(:delete, :drop, :scenario_id => @scenario.id, :variables_ids => [@scenario_variable.id])
      response.should render_template(:drop)
    end
  end
  
  def mock_scenario_variable(attrs = {})
    @mock_scenario_variable ||= Factory(:scenario_variable, {:user => @user}.merge(attrs))
  end
end
