require File.dirname(__FILE__) + "/../../../spec_helper"

describe Admins::Settings::ClientVersionsController do
  before(:each) do
    @client_version = Factory(:client_version)
    admins_login
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:client_versions).should_not be_empty
      assigns(:client_versions).should eq([@client_version])
    end
  end

  describe "GET show" do
    it "" do
      get :show, :id => @client_version.id
      response.should render_template(:show)
      assigns(:client_version).should eq(@client_version)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:client_version).should be_instance_of(ClientVersion)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :id => @client_version.id
      response.should render_template(:edit)
      assigns(:client_version).should eq(@client_version)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      before(:each) { @valid_params =  { :version => "0.99.16", :url => "http://lhvac.com/client99.16.exe", :release_date => Time.now.to_date.to_s } }
              
      it "should change the version count" do
        proc{ post :create, :client_version => @valid_params }.should change(ClientVersion, :count).by(1)
      end
      
      it "redirects to the created version" do
        post :create, :client_version => @valid_params
        response.should redirect_to(admins_settings_client_version_path(assigns(:client_version)))
      end
    end
  
    describe "with invalid params" do
      it "" do
        post :create, :client_version => { }
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do    
    describe "with valid params" do      
      it "updates the requested client_version" do
        put :update, :id => @client_version.id, :client_version => { :version => "0.99.17" }
        @client_version.reload.version.should == "0.99.17"
      end
      
      it "redirects to the version" do
        put :update, :id => @client_version.id, :client_version => { }
        response.should redirect_to(admins_settings_client_version_path(@client_version))
      end
    end
    
    describe "with invalid params" do  
      it "" do
        put :update, :id => @client_version.id, :client_version => { :version => "" }
        response.should render_template(:edit)
      end
    end
  end
  
  describe "DELETE destroy" do    
    it "destroys the requested client_version" do
      proc { delete :destroy, :id => @client_version.id }.should change(ClientVersion, :count).by(-1)
    end
  
    it "redirects to the client versions index" do
      delete :destroy, :id => @client_version.id
      response.should redirect_to(admins_settings_client_versions_path)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @admin.role_code = User::ROLES[:student]
      @admin.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions do
        response.should be_redirect
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
end
