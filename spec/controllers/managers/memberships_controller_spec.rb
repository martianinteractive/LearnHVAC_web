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
  
  # before(:each) do
  #   institution   = Factory(:institution)
  #   @manager      = Factory(:manager, :institution => institution)
  #   instructor    = Factory(:instructor, :institution => institution)
  #   @student      = Factory(:student)
  #   ms            = Factory(:master_scenario, :user => @manager)
  #   scenario_1    = Factory(:scenario, :master_scenario => ms, :name => 'scenario 1', :user => instructor)
  #   scenario_2    = Factory(:scenario, :master_scenario => ms, :name => 'scenario 2', :user => instructor)
  #   @group        = Factory(:group, :name => "Class 01", :creator => instructor, :scenario_ids => [scenario_1.id, scenario_2.id])
  #   
  #   Factory(:group_membership, :group => @group, :member => @student, :scenario => scenario_1)
  #   Factory(:group_membership, :group => @group, :member => @student, :scenario => scenario_2)
  #   
  #   Factory(:group_membership, :group => @group, :member => Factory(:guest), :scenario => scenario_2)
  #   Factory(:membership, :member => @manager, :scenario => scenario_1)
  #   
  #   login_as(@manager)
  # end
  # 
  # describe "DELETE :destroy" do
  #   it "" do
  #     proc { delete :destroy, :id => @student.id, :class_id => @group.id }.should change(GroupMembership, :count).by(-2)
  #   end
  #   
  #   it "" do
  #     delete :destroy, :id => @student.id, :class_id => @group.id
  #     response.should redirect_to(managers_class_path(@group))
  #   end
  # end
  # 
end
