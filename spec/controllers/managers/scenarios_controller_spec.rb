require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::ScenariosController do
  before(:each) do
    institution       = Factory(:institution)
    manager           = Factory(:manager, :institution => institution)
    instructor        = Factory(:instructor, :institution => institution)
    master_scenario   = Factory(:master_scenario, :user => Factory(:admin))
    @scenario         = Factory(:scenario, :user => instructor, :master_scenario => master_scenario)
    login_as(manager)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:scenarios).should eq([@scenario])
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :id => @scenario.id
      response.should render_template(:show)
      assigns(:scenario).should eq(@scenario)
    end
  end
  
  describe "GET access" do
    it "" do
      get :access, :id => @scenario.id
      response.should render_template(:access)
      assigns(:scenario).should eq(@scenario)
    end
  end
  
  describe "GET list" do
    it "" do
      get :list, :user_id => @scenario.user.id
      response.should render_template(:list)
      assigns(:scenarios).should eq([@scenario])
    end
  end
  
end
