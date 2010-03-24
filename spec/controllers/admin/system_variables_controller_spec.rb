require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::SystemVariablesController do

  before(:each) do
    @global_system_variable = Factory(:global_system_variable)
    admin_login
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:global_system_variables).should_not be_empty
    end
  end
  
  describe "GET show" do
    it "" do
      GlobalSystemVariable.expects(:find).with("37").returns(mock_global_var(:name => "global var", :description => "description"))
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:global_system_variable).should be(mock_global_var)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:global_system_variable).should be_instance_of(GlobalSystemVariable)
    end
  end
  
  describe "GET edit" do
    it "" do
      GlobalSystemVariable.expects(:find).with("37").returns(mock_global_var)
      get :edit, :id => "37"
      response.should render_template(:edit)
      assigns(:global_system_variable).should be(mock_global_var)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "should change the GlobalSystemVariable count" do
        proc{ post :create, :global_system_factory => Factory.attributes_for(:global_system_variable) }.should change(GlobalSystemVariable, :count).by(1)
      end
  
      it "redirects to the created global_system_variable" do
        post :create, :global_system_variable => Factory.attributes_for(:global_system_variable)
        response.should redirect_to(admin_system_variable_path(assigns(:global_system_variable)))
      end
    end
  
    pending "Define invalid attrs for global system var"
    describe "with invalid params" do
    end
  end
  
  describe "PUT update" do
    
    before(:each) do
      @global_system_variable = Factory(:global_system_variable)
    end
    
    describe "with valid params" do      
      it "updates the requested global_system_variable" do
        put :update, :id => @global_system_variable.id, :global_system_variable => { :name => "Cold var" }
        @global_system_variable.reload["name"].should == "Cold var"
      end
      
      it "redirects to the global_system_variable" do
        put :update, :id => @global_system_variable.id, :global_system_variable => { :name => "Cold var" }
        response.should redirect_to(admin_system_variable_path(@global_system_variable.id))
      end
    end
    
    pending "Define invalid attrs for global system var"
    describe "with invalid params" do  
    end
  end
  
  
  describe "DELETE destroy" do
    before(:each) do
      @global_system_variable = Factory(:global_system_variable)
    end
    
    it "destroys the requested global_system_variable" do
      proc { delete :destroy, :id => @global_system_variable.id }.should change(GlobalSystemVariable, :count).by(-1)
    end
  
    it "redirects to the global_system_variables list" do
      delete :destroy, :id => @global_system_variable.id
      response.should redirect_to(admin_system_variables_url)
    end
  end
  
  describe "Authorization" do
    it "should require an authenticated admin for all actions" do
      @admin.role_code = User::ROLES[:student]
      @admin.save
      authorize_actions do
        response.should redirect_to(default_path_for(@admin))
        flash[:notice].should == "You don't have the privileges to access this page"
      end
    end
  end
  
  
  def mock_global_var(attrs = {})
    @mock_global_variable ||= Factory(:global_system_variable, attrs)
  end
  
end
