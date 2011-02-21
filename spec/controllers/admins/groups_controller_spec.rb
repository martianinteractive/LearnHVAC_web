require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::GroupsController do

  let(:group) { mock_model(Group) }

  before{ login_as(:admin) }

  context "GET index" do
    it "" do
      Group.should_receive(:paginate).and_return([group])
      get :index
      response.should render_template(:index)
      assigns[:groups].should eq([group])
    end
  end

  context "GET show" do
    it "" do
      Group.should_receive(:find).with("37").and_return(group)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:group).should eq(group)
    end
  end

  context "GET new" do
    it "" do
      Group.should_receive(:new).and_return(group)
      get :new
      response.should render_template(:new)
      assigns(:group).should eq(group)
    end
  end

  context "GET edit" do
    it "" do
      Group.should_receive(:find).with("37").and_return(group)
      group.should_receive(:name)
      get :edit, :id => '37'
      response.should render_template(:edit)
      assigns(:group).should eq(group)
    end
  end

  context "POST create" do
    context "with valid params" do

      it "should create a group" do
        Group.should_receive(:new).with({'these' => 'params'}).and_return(group)
        group.should_receive(:save).and_return(:true)
        post :create, :group => {:these => 'params'}
        assigns(:group).should equal(group)
      end

      it "redirects to the created group" do
        Group.stub!(:new).and_return(mock_model(Group, :save => true))
        post :create, :group => {}
        response.should redirect_to(admins_class_path(assigns(:group)))
      end
    end

    context "with invalid params" do
      let(:group) { mock_model(Group, :save => false) }

      it "should expose a newly created but unsaved invoice as @group" do
        Group.stub!(:new).with({'these' => 'params'}).and_return(group)
        post :create, :group => {:these => 'params'}
        assigns(:group).should equal(group)

      end

      it "should re-render the 'new' template" do
        Group.stub!(:new).with({'these' => 'params'}).and_return(group)
        post :create, :group => {:these => 'params'}
        response.should render_template(:new)
      end
    end

  end

  context "PUT update" do
    let(:group) { mock_model(Group, :update_attributes => true) }

    context "with valid params" do
      it "updates the requested group" do
        Group.should_receive(:find).with("37").and_return(group)
        group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :group => {:these => 'params'}
      end

      it "should expose the requested invoice as @group" do
        Group.stub!(:find).and_return(group)
        put :update, :id => "1"
        assigns(:group).should equal(group)
      end

      it "redirects to the group" do
        Group.stub!(:find).and_return(group)
        put :update, :id => '37', :group => { }
        response.should redirect_to(admins_class_path(group))
      end
    end

    context "with invalid params" do
      let(:group) { mock_model(Group, :update_attributes => false, :name => 'bla') }

      it "should re-render the 'edit' template" do
        Group.stub!(:find).and_return(group)
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end


  describe "responding to DELETE destroy" do
    let(:group) { mock_model(Group, :destroy => true)}

    it "should destroy the requested group" do
      Group.should_receive(:find).with("37").and_return(group)
      group.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the invoices list" do
      Group.stub!(:find).and_return(group)
      delete :destroy, :id => "1"
      response.should redirect_to(admins_classes_path)
    end
  end

end
