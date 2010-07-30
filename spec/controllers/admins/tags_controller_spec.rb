require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::TagsController do
  before(:each) do
    admins_login
    Factory(:master_scenario, :user => @admin, :tag_list => "master, scenario, bar, baz")
    Factory(:master_scenario, :user => @admin, :tag_list => "master, scenario, foo, noez")
  end
  
  
  describe "GET index" do 
    it "" do
      get :index, :term => "ma"
      assigns(:tags).should_not be_empty
      assigns(:tags).first.name.should == "master"
    end
    
    it "" do
      get :index, :term => "a"
      assigns(:tags).should be_empty
    end
  end
  
end
