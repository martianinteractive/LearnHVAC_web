require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::GroupsController do
  let(:current_user) { Factory.stub(:manager) }

  before do
    controller.stub(:current_user).and_return(current_user)
    controller.stub_chain(:current_user, :institution, :scenarios).and_return([])
  end


  def mock_group(stubs={})
    @mock_group ||= mock_model(Group, {:name => 'bla'}.merge(stubs))
  end

  context "GET index" do
    it "should expose groups" do
      current_user.stub_chain(:institution, :groups, :paginate).and_return([mock_group])
      get :index
      assigns[:groups].should eq([mock_group])
    end

    it "should render the index template" do
      current_user.stub_chain(:institution, :groups, :paginate).and_return([mock_group])
      get :index
      response.should render_template(:index)
    end
  end

  context "GET show" do
    before { current_user.stub_chain(:institution, :groups, :find).and_return(mock_group) }

    it "should expose group" do
      get :show, :id => "37"
      assigns[:group].should eq(mock_group)
    end

    it "should render the show template" do
      get :show, :id => "37"
      response.should render_template(:show)
    end
  end

  context "GET new" do
    it "should expose variables" do
      Group.should_receive(:new).and_return(mock_group)
      get :new
      assigns[:group].should eq(mock_group)
      assigns[:scenarios].should_not be_nil
    end

    it "should render the new template" do
      Group.stub(:new).and_return(mock_group)
      get :new
      response.should render_template(:new)
    end
  end

  context "POST: create" do
    context "successfully" do
      before { mock_group.stub(:save).and_return(true) }

      it "should expose group" do
        Group.should_receive(:new).with({"name" => "bla"}).and_return(mock_group)
        post :create, :group => {:name => "bla"}
        assigns[:group].should eq(mock_group)
      end

      it "should redirect" do
        Group.stub(:new).and_return(mock_group)
        post :create, :group => {}
        response.should redirect_to(managers_class_path(assigns[:group]))
      end
    end

    context "unsuccessfully" do
      before { mock_group.stub(:save).and_return(false) }

      it "should expose variables" do
        Group.should_receive(:new).with({"name" => "bla"}).and_return(mock_group)
        post :create, :group => {:name => "bla"}
        assigns[:group].should eq(mock_group)
        assigns[:scenarios].should_not be_nil
      end

      it "should render the new template" do
        Group.stub(:new).and_return(mock_group)
        post :create, :group => {}
        response.should render_template(:new)
      end
    end
  end

  context "PUT update" do
    before { current_user.stub_chain(:institution, :groups, :find).and_return(mock_group) }

    context "successfuly" do
      before { mock_group.stub(:update_attributes).and_return(true) }

      it "should expose group" do
        mock_group.should_receive(:update_attributes).and_return(true)
        put :update, :id => "37", :group => {}
        assigns[:group].should eq(mock_group)
      end

      it "should redirect" do
        mock_group.stub(:update_attributes).and_return(true)
        put :update, :id => "37", :group => {}
        response.should redirect_to(managers_class_path(assigns[:group]))
      end
    end

    context "unsuccessfully" do
      before { mock_group.stub(:update_attributes).and_return(false) }

      it "should expose variables" do
        mock_group.should_receive(:update_attributes).and_return(false)
        put :update, :id => "37", :group => {}
        assigns[:group].should eq(mock_group)
        assigns[:scenarios].should_not be_nil
      end

      it "should render the edit template" do
        mock_group.stub(:update_attributes).and_return(false)
        put :update, :id => "37", :group => {}
        response.should render_template(:edit)
      end
    end
  end

  context "DELETE destroy" do
    before { current_user.stub_chain(:institution, :groups, :find).and_return(mock_group) }

    it "should expose group" do
      delete :destroy, :id => "37"
      assigns[:group].should eq(mock_group)
    end

    it "should redirect" do
      delete :destroy, :id => "37"
      response.should redirect_to(managers_class_path)
    end
  end
end
