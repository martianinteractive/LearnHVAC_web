require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::MembershipsController do
  before(:each) do
    institution   = Factory(:institution)
    admin         = Factory(:admin)
    instructor    = Factory(:instructor, :institution => institution)
    student       = Factory(:student)
    @group        = Factory(:group, :name => "Class 01", :creator => instructor)
    @student_membership  = Factory(:membership, :group => @group, :member => student)
    login_as(instructor)
  end
  
  describe "DELETE :destroy" do
    it "should delete a student membership" do
      proc { delete :destroy, :class_id => @group.id, :id => @student_membership.id }.should change(Membership, :count).by(-1)
    end
    
    it "" do
      delete :destroy, :class_id => @group.id, :id => @student_membership.id
      response.should redirect_to(instructors_class_path(@group))
    end
  end
end
