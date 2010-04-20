require File.dirname(__FILE__) + "/../../spec_helper"

describe Directory::ScenariosController do
  before(:each) do
    @institution      = Factory(:institution)
    @private_inst     = Factory(:institution, :name => "EAFIT")
    @instructor       = user_with_role(:instructor, 1, :institution => @institution)
    master_scenario   = Factory(:master_scenario, :user => user_with_role(:admin))
    @public_scenario  = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario, :public => true)
    @private_scenario = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario, :public => false)
    login_as(@instructor)
  end
  
  describe "GET :show" do
    
    it "" do
      get :show, :institution_id => @institution.id, :id => @public_scenario.id
      response.should render_template(:show)
      assigns(:scenario).should eq(@public_scenario)
    end
    
    pending "respond if with 404 when trying to view a private scenario."
    # it "should not show private scenarios" do
    #   get :show, :institution_id => @institution.id, :id => @private_scenario.id
    #   response.should render_template(:show)
    #   assigns(:scenario).should be_nil
    # end
  end
end
