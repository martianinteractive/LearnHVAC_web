require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::UsersController do
  
  before(:each) do
    admin_login
  end 
  
  describe "GET index" do
    it "assigns all users as @users" do
      User.expects(:order).returns([mock_user])
      get :index
      response.should render_template(:index)
      assigns(:users).should == [mock_user]
    end
  end
  
  describe "GET show" do
    it "assigns the requested user as @user" do
      User.expects(:find).with("37").returns(mock_user)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:user).should be(mock_user)
    end
  end
  
  describe "GET new" do
    it "assigns a new user as @user" do
      get :new
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
        proc{ post :create, :user => Factory.attributes_for(:user).merge(:first_name => "Jame$") }.should_not change(User, :count)
        assigns(:user).should be_instance_of(User)
      end
      
      it "re-renders the 'new' template" do
        post :create, :user => Factory.attributes_for(:user).merge(:first_name => "Jame$")
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
      proc { delete :destroy, :id => @user.id }.should change(User, :count).by(-1)
      response.should redirect_to(admin_users_path)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @admin.role_code = User::ROLES[:student]
      @admin.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions do
        response.should redirect_to(default_path_for(@admin))
        flash[:notice].should == "You don't have the privileges to access this page"
      end
    end
  end
  
  def mock_user(attrs = {})
    @mock_user ||= Factory(:user, attrs)
  end 

end
