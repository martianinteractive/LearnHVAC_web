require File.dirname(__FILE__) + "/../../spec_helper"

describe Students::GroupsController do

  let(:group) { mock_model(Group, :name => "test") }
  let(:current_user) { Factory.stub(:student) }

  before { controller.stub!(:current_user).and_return(current_user) }

  context "GET index" do
    before { current_user.stub_chain(:groups, :paginate).and_return([group]) }

    it "" do
      get :index
      response.should render_template(:index)
    end

    it "" do
      get :index
      assigns[:groups].should eq([group])
    end

    it "" do
      current_user.stub_chain(:groups, :paginate).and_return([stub, stub])
      get :index
    end
  end

  context "GET show" do
    before { current_user.stub_chain(:groups, :find).and_return(group) }

    it "" do
      get :show, :id => group.id
      response.should render_template(:show)
    end

    it "" do
      get :show, :id => group.id
      assigns[:group].should == group
    end
  end

end
