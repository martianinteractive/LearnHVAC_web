require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::AccessController do
  render_views
  before(:each) do
    @instructor       = Factory(:instructor)
    @admin            = Factory(:admin)
    @student          = Factory(:student)
    master_scenario   = Factory(:master_scenario, :user => @admin)
    @scenario         = Factory(:scenario, :user => @instructor, :master_scenario => master_scenario)
    @group            = Factory(:group, :creator => @instructor, :scenario_ids => [@scenario.id])
    
    @admin_membership  = Factory(:individual_membership, :member => @admin, :scenario => @scenario)
    @student_membership = Factory(:group_membership, :member => @student, :group => @group, :scenario => @scenario)
    
    login_as @instructor
  end
  
  describe "GET :index" do
    it "should description" do
      get :index, :scenario_id => @scenario.id
      response.should render_template(:index)
      assigns(:scenario).should == @scenario
      assigns(:scenario).groups.should_not be_empty
      assigns(:scenario).groups.first.should == @group
      assigns(:scenario).users.admin.first.should == @admin
      assigns(:scenario).users.student.first.should == @student
    end
  end
  
  describe "DELETE :destroy" do    
    it "" do
      proc { delete :destroy, :id => @student_membership.id, :scenario_id => @scenario.id }.should change(GroupMembership, :count).by(-1)
    end
    
    it "" do
      delete :destroy, :id => @student_membership.id, :scenario_id => @scenario
      response.should redirect_to([:instructors, @scenario, :accesses])
    end
    
    it "should not destroy a NON student membership" do
      proc { delete :destroy, :id => @admin_membership.id, :scenario_id => @scenario.id }.should raise_error      
    end
  end

end
