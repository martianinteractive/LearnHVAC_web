require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::InstructorsController do
  before(:each) do
    @institution = Factory(:institution)
    @instructor  = user_with_role(:instructor, 1, :institution => @institution)
    @manager     = user_with_role(:manager, 1, :institution => @institution)
    login_as(@manager)
  end
  
  describe "GET :index" do
    it "" do
      get :index
      assigns(:instructors).should_not be_empty
      assigns(:instructors).should eq([@instructor])
      response.should render_template(:index)
    end
  end
  
  describe "GET :show" do
    it "" do
      get :show, :id => @instructor.id
      response.should render_template(:show)
      assigns(:instructor).should eq(@instructor)
    end
  end
  
  describe "GET :new" do
    it "" do
      get :new
      assigns(:instructor).should be_instance_of(User)
      response.should render_template(:new)
    end
  end
  
  describe "GET edit" do
    it "assigns the requested user as @instructor" do
      get :edit, :id => @instructor.id
      response.should render_template(:edit)
      assigns(:instructor).should eq(@instructor)
    end
  end
  
  describe "GET :edit" do
    it "should description" do
    end
  end
  
  describe "POST create" do
  
    describe "with valid params" do
      it "assigns a newly created user as @instructor" do
        proc{ post :create, :user => Factory.attributes_for(:user) }.should change(User, :count).by(1)
        assigns(:instructor).should be_instance_of(User)
      end
      
      it "should assign the new @instructor as part of the current_user institution" do
        post :create, :user => Factory.attributes_for(:user)
        assigns(:instructor).institution.should == @manager.institution
      end
      
      it "should create the new @instructor as an instructor" do
        post :create, :user => Factory.attributes_for(:user)
        assigns(:instructor).role_code.should == User::ROLES[:instructor]
      end
      
      it "redirects to the created user" do
        post :create, :user => Factory.attributes_for(:user)
        response.should redirect_to(managers_instructor_path(assigns(:instructor)))
      end
    end
  
    describe "with invalid params" do
      it "" do
        post :create, :user => Factory.attributes_for(:user).merge(:first_name => "Jame$")
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do
        
    describe "with valid params" do      
      it "updates the requested instructor" do
        put :update, :id => @instructor.id, :user => { :first_name => "Joe" }
        assigns(:instructor).should == @instructor.reload
        @instructor.first_name.should == "Joe"
      end
      
      it "redirects to the instructor" do
        put :update, :id => @instructor.id, :user => { :last_name => "Doex" }
        response.should redirect_to(managers_instructor_path(@instructor))
      end
      
      it "should assign the manager institution even if a institution_id is passed by a malicious user" do
        institution2 = Factory(:institution, :name => "EAFIT")
        put :update, :id => @instructor.id, :user => { :institution_id => institution2.id }
        assigns(:instructor).institution.should == @institution
      end
    end
      
    describe "with invalid params" do  
      it "not update the instructor" do
        put :update, :id => @instructor.id, :user => { :first_name => "Jame$", :last_name => "" }
        assigns(:instructor).should_not equal(@instructor.reload)
        assigns(:instructor).should be_instance_of(User)
      end
      
      it "" do
        put :update, :id => @instructor.id, :user => { :first_name => "Jame$", :last_name => "" }
        response.should render_template('edit')
      end
    end
  end
  
  describe "DELETE destroy" do
    it "" do
      proc { delete :destroy, :id => @instructor.id }.should change(User, :count).by(-1)
      response.should redirect_to(managers_instructors_path)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @manager.role_code = User::ROLES[:instructor]
      @manager.save
    end
    
    it "should require a manager for all actions" do
      authorize_actions do
        response.should redirect_to(default_path_for(@manager))
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
  
  
end
