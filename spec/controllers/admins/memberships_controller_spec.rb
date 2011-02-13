require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::MembershipsController do
  let(:current_user) { Factory.stub(:admin) }
  
  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
  end
  
  def mock_group(stubs={})
    @mock_group ||= mock_model(Group, stubs).as_null_object
  end
  
  describe "DELETE :destroy" do
    it "should destroy the membership" do
      Group.should_receive(:find).with('37').and_return(mock_group)
      mock_group.stub_chain(:memberships, :where, :destroy_all)
      mock_group.should_receive(:memberships)
      delete :destroy, :class_id => '37', :id => '1'
    end
    
    it "should redirect back" do
      Group.should_receive(:find).with('37').and_return(mock_group)
      delete :destroy, :class_id => '37', :id => '1'
      response.should redirect_to admins_class_path(assigns[:group])
    end
  end
end
