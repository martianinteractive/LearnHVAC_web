require File.dirname(__FILE__) + "/../../spec_helper"

describe Directory::VariablesController do
  before(:each) do
    @institution          = Factory(:institution)
    @instructor           = user_with_role(:instructor, 1, :institution => @institution)
    @master_scenario      = Factory(:master_scenario, :user => user_with_role(:admin))
    @public_scenario      = Factory(:scenario, :user => @instructor, :master_scenario => @master_scenario, :public => true)
    @variable             = Factory(:scenario_variable, :scenario => @public_scenario)
    login_as(@instructor)
  end
  
  pending "Fix :index with controller stubbing when available"
  describe "GET index" do
    it "" do
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
