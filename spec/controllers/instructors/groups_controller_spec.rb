require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::GroupsController do
  let(:current_user) { Factory.stub(:instructor) }
  
  before { controller.stub(:current_user).and_return(current_user) }
  
  def mock_group(stubs={})
    @mock_group ||= mock_model(Group, {:name => ""}.merge(stubs))
  end
  
  describe "GET index" do
    before { current_user.stub_chain(:managed_groups, :paginate).and_return([mock_group]) }
    
    it "should expose groups" do
      get :index
      assigns[:groups].should eq([mock_group])
    end
    
    it "should render index" do
      get :index
      response.should render_template(:index)
    end
  end
  
  describe "GET show" do
    before { current_user.stub_chain(:managed_groups, :find).and_return(mock_group) }
    
    it "should expose group" do
      get :show, :id => "37"
      assigns[:group].should eq(mock_group)
    end
    
    it "should render show template" do
      get :show, :id => "37"
      response.should render_template(:show)
    end
  end
  
  describe "GET new" do
    before { current_user.stub_chain(:managed_groups, :build).and_return(mock_group) }
    
    it "should expose new group" do
      get :new
      assigns[:group].should eq(mock_group)
    end
    
    it "should render new" do
      get :new
      response.should render_template(:new)
    end
  end
  
  describe "GET edit" do
    before { current_user.stub_chain(:managed_groups, :find).and_return(mock_group) }
    
    it "should exponse the group" do
      get :edit, :id => "37"
      assigns[:group].should eq(mock_group)
    end
    
    it "should render edit template" do
      get :edit, :id => "37"
      response.should render_template(:edit)
    end
  end
  
  describe "POST create" do
    describe "successfully" do
      before do
        mock_group(:creator= => "", :save => true)
        Group.stub(:new).and_return(mock_group)
      end
      
      it "should init group" do
        post :create, :group => {}
      end
      
      it "should exponse group" do
        post :create, :group => {}
        assigns[:group].should eq(mock_group)
      end
      
      it "should redirect" do
        post :create, :group => {}
        response.should redirect_to(instructors_class_path(assigns[:group]))
      end
    end
    
    describe "unsuccessfully" do
      before do
        mock_group(:creator= => "", :save => false)
        Group.stub(:new).and_return(mock_group)
      end
      
      it "should init group" do
        Group.should_receive(:new).and_return(mock_group)
        post :create, :group => {}
      end
      
      it "should exponse group" do
        post :create, :group => {}
        assigns[:group].should eq(mock_group)
      end
      
      it "should render edit" do
        post :create, :group => {}
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do
    describe "successfully" do
      before do
        mock_group(:update_attributes => true)
        current_user.stub_chain(:managed_groups, :find).and_return(mock_group)
      end
      
      it "should expose group" do
        put :update, :id => "37", :group => {}
        assigns[:group].should eq(mock_group)
      end
      
      it "should update" do
        mock_group.should_receive(:update_attributes).and_return(true)
        put :update, :id => "37", :group => {}
      end
      
      it "should redirect" do
        put :update, :id => "37", :group => {}
        response.should redirect_to(instructors_class_path(assigns[:group]))
      end
    end
    
    describe "unssuccessfully" do
      before do
        mock_group(:update_attributes => false)
        current_user.stub_chain(:managed_groups, :find).and_return(mock_group)
      end
      
      it "should expose group" do
        put :update, :id => "37", :group => {}
        assigns[:group].should eq(mock_group)
      end
      
      it "should update" do
        mock_group.should_receive(:update_attributes).and_return(false)
        put :update, :id => "37", :group => {}
      end
      
      it "should render edit" do
        put :update, :id => "37", :group => {}
        response.should render_template(:edit)
      end
    end
  end
  
  describe "DELETE destroy" do
    before do
      current_user.stub_chain(:managed_groups, :find).and_return(mock_group)
    end
    
    it "should expose group" do
      delete :destroy, :id => "37"
      assigns[:group].should eq(mock_group)
    end
    
    it "should destroy" do
      mock_group.should_receive(:destroy).and_return(true)
      delete :destroy, :id => "37"
    end
    
    it "should redirect" do
      delete :destroy, :id => "37"
      response.should redirect_to(instructors_classes_url)
    end
  end
end
