require File.dirname(__FILE__) + "/../../spec_helper"

describe Directory::InstitutionsController do
  context "" do
    it "" do
      pending
    end
  end
  
  # 
  # before(:each) do
  #   @institution      = Factory(:institution)
  #   @instructor       = Factory(:instructor, :institution => @institution)
  #   master_scenario   = Factory(:master_scenario, :user => Factory(:admin))
  #   @public_scenario  = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario, :public => true)
  #   @private_scenario = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario, :public => false)
  #   login_as(@instructor)
  # end
  # 
  # describe "GET :index" do
  #   it "" do
  #     get :index
  #     response.should render_template(:index)
  #     assigns(:institutions).should have(1).institution
  #     assigns(:institutions).first.should eq(@institution)
  #   end
  # end
  # 
  # describe "GET :show" do
  #   it "" do
  #     get :show, :id => @institution.id
  #     response.should render_template(:show)
  #     assigns(:institution).should_not be_nil
  #     assigns(:institution).should eq(@institution)
  #   end
  # end
  # 
end
