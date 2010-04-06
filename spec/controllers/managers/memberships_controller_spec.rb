require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::MembershipsController do
  before(:each) do
    institution   = Factory(:institution)
    @manager      = user_with_role(:manager, 1, :institution => institution)
    instructor    = user_with_role(:instructor, 1, :institution => institution)
    @student      = user_with_role(:student)
    @group        = Factory.build(:group, :name => "Class 01", :instructor => instructor)
    @group.expects(:scenario_validator).returns(true) #skip scenarios assignment.
    @group.save
    @membership   = Factory(:membership, :group => @group, :student => @student)
    login_as(@manager)
  end
  
  describe "DELETE :destroy" do
    it "" do
      proc { delete :destroy, :group_id => @group.id, :id => @membership.id }.should change(Membership, :count).by(-1)
    end
    
    it "" do
      delete :destroy, :group_id => @group.id, :id => @membership.id
      response.should redirect_to(managers_group_path(@group))
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @manager.role_code = User::ROLES[:instructor]
      @manager.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions(:delete => [ :destroy ]) do
        response.should redirect_to(default_path_for(@manager))
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
  
end
