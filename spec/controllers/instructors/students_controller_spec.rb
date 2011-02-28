require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::StudentsController do
  let(:current_user) { Factory.stub(:instructor) }
  let(:mock_student) { mock_model(User) }

  def mock_group(stubs={})
    @mock_group ||= mock_model(Group, stubs)
  end

  before do
    controller.stub(:current_user).and_return(current_user)
    current_user.stub_chain(:managed_groups, :find).and_return(mock_group)
    mock_group.stub_chain(:members, :find).and_return(mock_student)
  end

  context "GET show" do
    it "should exponse student" do
      get :show, :class_id => "37", :id => "1"
      assigns[:student].should eq(mock_student)
    end

    it "should render show" do
      get :show, :class_id => "37", :id => "1"
      response.should render_template(:show)
    end
  end
end
