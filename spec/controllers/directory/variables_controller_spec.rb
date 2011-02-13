require File.dirname(__FILE__) + "/../../spec_helper"

describe Directory::VariablesController do
  before(:each) do
    @institution          = Factory(:institution)
    @instructor           = Factory(:instructor, :institution => @institution)
    @master_scenario      = Factory(:master_scenario, :user => Factory(:admin))
    @public_scenario      = Factory(:scenario, :user => @instructor, :master_scenario => @master_scenario, :public => true)
    @variable             = Factory(:scenario_variable, :scenario => @public_scenario)
    login_as(@instructor)
  end
  
  describe "GET index" do
    it "" do
      get :index, :institution_id => @institution.id, :scenario_id => @public_scenario.id
      response.should render_template(:index)
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :institution_id => @institution.id, :scenario_id => @public_scenario.id, :id => @variable.id
      response.should render_template(:show)
      assigns(:variable).should eq(@variable)
    end
  end

end
