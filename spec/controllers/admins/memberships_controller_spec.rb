require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::MembershipsController do
  before(:each) do
    institution   = Factory(:institution)
    admin         = Factory(:admin)
    instructor    = Factory(:instructor, :institution => institution)
    @group        = Factory(:group, :name => "Class 01", :instructor => instructor)
    @instructor_membership  = Membership.where(:group_id => @group.id, :member_id => instructor.id).first
    login_as(admin)
  end
  
  describe "DELETE :destroy" do
    it "should delete a student membership" do
      proc { delete :destroy, :id => @instructor_membership.id }.should change(Membership, :count).by(-1)
    end
    
    it "" do
      delete :destroy, :id => @instructor_membership.id
      response.should redirect_to(admins_class_path(@group))
    end
  end
end
