require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::MembershipsController do
  before(:each) do
    admin         = Factory(:admin)
    instructor    = Factory(:instructor, :institution => Factory(:institution))
    ms            = Factory(:master_scenario, :user => admin)
    scenario_1    = Factory(:scenario, :master_scenario => ms, :name => 'scenario 1', :user => instructor)
    scenario_2    = Factory(:scenario, :master_scenario => ms, :name => 'scenario 2', :user => instructor)
    @group        = Factory(:group, :name => "Class 01", :creator => instructor, :scenario_ids => [scenario_1.id, scenario_2.id])
    @student      = Factory(:student)
    
    Factory(:group_membership, :group => @group, :member => @student, :scenario => scenario_1)
    Factory(:group_membership, :group => @group, :member => @student, :scenario => scenario_2)
    
    Factory(:group_membership, :group => @group, :member => Factory(:guest), :scenario => scenario_2)
    Factory(:membership, :member => admin, :scenario => scenario_1)
    
    login_as(admin)
  end
  
  describe "DELETE :destroy" do
    it "should delete all the group memberships for the given user." do
      proc { delete :destroy, :id => @student.id, :class_id => @group.id }.should change(GroupMembership, :count).by(-2)
    end
    
    it "" do
      delete :destroy, :id => @student.id, :class_id => @group.id
      response.should redirect_to(admins_class_path(@group))
    end
  end
end
