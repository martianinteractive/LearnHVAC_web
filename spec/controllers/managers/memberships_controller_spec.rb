require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::MembershipsController do
  let(:current_user) { Factory.stub(:manager) }

  before do
    controller.stub(:current_user).and_return(current_user)
    current_user.stub_chain(:institution, :groups, :find).and_return(mock_group)
    mock_group.stub_chain(:memberships, :where, :destroy_all).and_return(true)
  end
  
  def mock_group(stubs={})
    @mock_group ||= mock_model(Group, stubs)
  end
  
  context "DELETE destroy" do    
    it "should delete" do
      delete :destroy, :class_id => "1", :id => "37"
      assigns[:group].should eq(mock_group)
    end
    
    it "should redirect" do
      delete :destroy, :class_id => "1", :id => "37"
      response.should redirect_to(managers_class_path(assigns[:group]))
    end
  end
end
