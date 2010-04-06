require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::UsersController do
  
  before(:each) do
    admin_login
  end 
  
  describe "GET index" do
    
    before{ create_users }
    
    it "should filter by role if requested" do
      User::ROLES.keys.each do |role|
        get :index, :role => role
        response.should render_template(:index)
        assigns(:users).each { |user| user.role.should == role }
      end
    end
    
    it "should assigns all users if not role is specified" do
      lambda { get :index }.should raise_error
    end

  end
  
  describe "POST search" do
    
    before { create_users }
    
    it "should find users based on the given parameter" do
      post :search, :q => "adm", :role => 'admin'
      response.should render_template(:index)
      assigns(:users).should_not be_empty
    end
    
  end
  
  describe "GET show" do
    it "assigns the requested user as @user" do
      create_users
      get :show, :id => @admin.id
      response.should render_template(:show)
      assigns(:user).should eq(@admin)
    end
  end
  
  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, :role => 'admin'
      response.should render_template(:new)
      assigns(:user).should be_instance_of(User)
    end
  end
  
  describe "GET edit" do
    it "assigns the requested user as @user" do
      User.expects(:find).with("37").returns(mock_user)
      get :edit, :id => "37"
      response.should render_template(:edit)
      assigns(:user).should be(mock_user)
    end
  end
  
  describe "POST create" do
  
    describe "with valid params" do
      it "assigns a newly created user as @user" do
        proc{ post :create, :user => Factory.attributes_for(:user) }.should change(User, :count).by(1)
        assigns(:user).should be_instance_of(User)
      end
  
      it "redirects to the created user" do
        post :create, :user => Factory.attributes_for(:user)
        response.should redirect_to(admin_user_url(assigns(:user)))
      end
    end
  
    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        proc{ post :create, :role => 1, :user => Factory.attributes_for(:user).merge(:first_name => "Jame$") }.should_not change(User, :count)
        assigns(:user).should be_instance_of(User)
      end
      
      it "re-renders the 'new' template" do
        post :create, :role => 1, :user => Factory.attributes_for(:user).merge(:first_name => "Jame$"), :role => 1
        response.should render_template(:new)
      end
    end

  end
  
  describe "PUT update" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "with valid params" do      
      it "updates the requested user" do
        put :update, :id => @user.id, :user => { :first_name => "Joe" }
        assigns(:user).should == @user.reload
        @user.first_name.should == "Joe"
      end
      
      it "redirects to the user" do
        put :update, :id => @user.id, :user => { :last_name => "Doex" }
        response.should redirect_to(admin_user_url(@user))
      end
    end
      
    describe "with invalid params" do  
      it "not update the user" do
        put :update, :id => @user.id, :user => { :first_name => "Jame$", :last_name => "" }
        assigns(:user).should_not equal(@user.reload)
        
        assigns(:user).should be_instance_of(User)
      end
      
      it "re-renders the 'edit' template" do
        put :update, :id => @user.id, :user => { :first_name => "Jame$", :last_name => "" }
        response.should render_template('edit')
      end
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "destroys the requested user" do
      role = @user.role
      proc { delete :destroy, :id => @user.id }.should change(User, :count).by(-1)
      response.should redirect_to(admin_users_path(:role => role))
    end
  end
  
  describe "Authentication" do
    before(:each) do
      user_logout
    end
    
    it "should require an admin user for all actions" do
      authorize_actions do
        response.should redirect_to(login_path)
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
  
  def mock_user(attrs = {})
    @mock_user ||= Factory(:user, attrs)
  end
  
  def create_users
    institution = Factory(:institution)
    @admin.update_attributes(:institution_id => institution.id)
    @instructor = user_with_role(:instructor, :institution => institution)
    @manager    = user_with_role(:institution_manager, :institution => institution)
    @student    = user_with_role(:student, :institution => institution)
    @guest      = user_with_role(:guest, :institution => institution)
  end

end
