require File.dirname(__FILE__) + "/../../spec_helper"

describe InstitutionManagers::InstructorsController do
  before(:each) do
    @institution = Factory(:institution)
    @instructor  = user_with_role(:instructor, 1, :institution => @institution)
    @manager     = user_with_role(:institution_manager, 1, :institution => @institution)
    login_as(@manager)
  end
  
  describe "GET :index" do
    it "" do
      get :index
      assigns(:instructors).should_not be_empty
      assigns(:instructors).should eq([@instructor])
      response.should render_template(:index)
    end
  end
  
end
