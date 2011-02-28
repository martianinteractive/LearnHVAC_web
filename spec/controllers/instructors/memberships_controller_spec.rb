require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::MembershipsController do
  
  let(:current_user) { Factory.stub(:instructor) }
  let(:mock_membership) { mock_model(Membership) }
  let(:mock_group) { mock_model(Scenario) }

  before { controller.stub(:current_user).and_return(current_user) } 
  
  describe "DELETE destroy" do
    before do
      current_user.stub_chain(:managed_groups, :find).and_return(mock_group)
      mock_group.stub_chain(:memberships, :where, :destroy_all).and_return(true)
    end
    
    it "should expose group" do
      delete :destroy, :id => "1", :class_id => "37"
      assigns[:group].should eq(mock_group)
    end
    
    it "should expose group" do
      delete :destroy, :id => "1", :class_id => "37"
      response.should redirect_to(instructors_class_path(assigns[:group]))
    end
  end
end
