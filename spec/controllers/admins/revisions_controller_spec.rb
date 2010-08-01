require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::RevisionsController do
  # before(:each) do
  #    admins_login
  #    @master_scenario = Factory(:master_scenario, :name => "Summer Day in DC", :user => @admin)
  #    @master_scenario.name = "Winter Day in DC"
  #    @master_scenario.save
  #  end
  # 
  #  describe "GET index" do
  #    it "" do
  #      get :index, :master_scenario_id => @master_scenario.id
  #      response.should render_template(:index)
  #      assigns(:versions).should_not be_empty
  #      assigns(:versions).count.should == 1
  #      assigns(:versions).first.name.should == "Summer Day in DC"
  #    end
  #  end
  #  
  #  describe "GET show" do
  #    it "" do
  #      get :show, :master_scenario_id => @master_scenario.id, :id => "1"
  #      response.should render_template(:show)
  #      assigns(:version).should_not be_nil
  #      assigns(:version).name.should == "Summer Day in DC"
  #    end
  #  end
  # 
  # describe "Authorization" do
  #   before(:each) do
  #     @admin.role_code = User::ROLES[:instructor]
  #     @admin.save
  #   end
  #   
  #   it "should require an admin user for all actions" do
  #     authorize_actions({:get => [:index, :show]}) do
  #       response.should redirect_to(default_path_for(@admin))
  #       flash[:notice].should == "You don't have privileges to access that page"
  #     end
  #   end
  # end
end
