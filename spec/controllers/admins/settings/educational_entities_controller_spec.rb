require File.dirname(__FILE__) + "/../../../spec_helper"

describe Admins::Settings::EducationalEntitiesController do

  before(:each) do
    @college = Factory(:college, :value => "Massachusetts Institute of Technology")
    admins_login
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:colleges).should_not be_empty
    end
  end
    
  describe "GET show" do
    it "" do
      get :show, :id => @college.id
      response.should render_template(:show)
      assigns(:college).should eq(@college)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:college).should be_instance_of(College)
    end
  end
  
  describe "GET edit" do
    it "" do
      get :edit, :id => @college.id
      response.should render_template(:edit)
      assigns(:college).should eq(@college)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "should change the Colleges count" do
        proc{ post :create, :college => { :value => "EAFIT" }  }.should change(College, :count).by(1)
      end
  
      it "redirects to the created college" do
        post :create, :college => { :value => "EAFIT" }
        response.should redirect_to(admins_settings_educational_entity_path(assigns(:college)))
      end
    end
  end
  
  describe "POST search" do
    it "" do
      post :search, :q => "institute"
      assigns(:colleges).should == [@college]
      response.should render_template(:index)
    end
    
    it "" do
      post :search, :q => "universidad"
      assigns(:colleges).should be_empty
      response.should render_template(:index)
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do      
      it "updates the requested " do
        put :update, :id => @college.id, :college => { :value => "EAFIT" }
        assigns(:college).should == @college.reload
        @college.value.should == "EAFIT"
      end
      
      it "redirects to the College" do
        put :update, :id => @college.id, :college => { :value => "EAFIT" }
        response.should redirect_to(admins_settings_educational_entity_path(@college))
      end
    end
  end
  
  describe "DELETE destroy" do
    it "destroys the requested college" do
      proc { delete :destroy, :id => @college.id }.should change(College, :count).by(-1)
    end
  
    it "redirects to colleges#index" do
      delete :destroy, :id => @college.id
      response.should redirect_to(admins_settings_educational_entities_path)
    end
  end

end
