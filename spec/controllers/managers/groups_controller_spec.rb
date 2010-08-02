require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::GroupsController do
  render_views
  
  before(:each) do
    institution   = Factory(:institution)
    @manager      = Factory(:manager, :institution => institution)
    @instructor   = Factory(:instructor, :institution => institution)
    @group        = Factory(:group, :name => "Class 01", :creator => @instructor)
    login_as(@manager)
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:groups).should_not be_empty
      assigns(:groups).should eq([@group])
    end
  end
  
  describe "GET show" do
    it "" do
      get :show, :id => @group.id
      response.should render_template(:show)
      assigns(:group).should eq(@group)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:group).should be_instance_of(Group)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :id => @group.id
      response.should render_template(:edit)
      assigns(:group).should eq(@group)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      
      it "should change the Group count" do
        proc{ post :create, 
              :group => {:name => "monkeygroup", :code => "0973872", :creator => @instructor} 
            }.should change(Group, :count).by(1)
      end
      
      it "redirects to the created group" do
        post :create, :group => {:name => "monkeygroup", :code => "0973872", :creator => @instructor} 
        response.should redirect_to(managers_class_path(assigns(:group)))
      end
    end
  
    describe "with invalid params" do
      it "should render new template" do
        post :create, :group => {:name => "", :code => "0973872"}
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested group" do
        put :update, :id => @group.id, :group => { :name => "CS Group" }
        @group.reload.name.should == "CS Group"
      end
      
      it "" do
        put :update, :id => @group.id, :group => { }
        response.should redirect_to(managers_class_path(@group))
      end
    end
    
    describe "with invalid params" do  
      it "" do
        put :update, :id => @group.id, :group => { :name => "" }
        response.should render_template(:edit)
      end
    end
  end
  
  describe "DELETE destroy" do    
    it "destroys the requested group" do
      proc { delete :destroy, :id => @group.id }.should change(Group, :count).by(-1)
    end
  
    it "redirects to the instructor groups list" do
      delete :destroy, :id => @group.id
      response.should redirect_to(managers_class_path)
    end
  end
  
end

