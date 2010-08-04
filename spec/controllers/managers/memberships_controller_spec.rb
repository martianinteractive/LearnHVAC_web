require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::MembershipsController do
  before(:each) do
    institution   = Factory(:institution)
    @manager      = Factory(:manager, :institution => institution)
    instructor    = Factory(:instructor, :institution => institution)
    @student      = Factory(:student)
    @group        = Factory(:group, :name => "Class 01", :creator => instructor)
    @membership   = Factory(:membership, :group => @group, :member => @student)
    login_as(@manager)
  end
  
  describe "DELETE :destroy" do
    it "" do
      proc { delete :destroy, :class_id => @group.id, :id => @membership.id }.should change(GroupMembership, :count).by(-1)
    end
    
    it "" do
      delete :destroy, :class_id => @group.id, :id => @membership.id
      response.should redirect_to(managers_class_path(@group))
    end
  end
  
end
