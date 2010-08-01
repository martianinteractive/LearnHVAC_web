require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::UsersController do
  before(:each) do
    @admin = Factory(:admin)
    login_as(@admin)
  end

  describe "GET index" do
    before(:each) { get :index, :role => 'admin', :requirements=>{:role => /[a-z]/} }
      
    it { response.should render_template(:index) }
    it { assigns(:users).should == [@admin] }
  end
  
  describe "POST search" do
    before(:each) { post :search, :q => "love", :role => 'admin', :requirements=>{:role => /[a-z]/} }
  
    it { response.should render_template(:index) }
    it { assigns(:users).should == [@admin] }
  end
   
  describe "GET show" do
    it "assigns the requested user as @user" do
      get :show, :id => @admin.id, :role => 'admin', :requirements=>{:role => /[a-z]/}
      response.should render_template(:show)
      assigns(:user).should eq(@admin)
    end
  end
  
  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, :role => 'admin', :requirements=>{:role => /[a-z]/}
      response.should render_template(:new)
      assigns(:user).should be_instance_of(User)
    end
  end
   
  describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, :id => @admin.id, :role => 'admin', :requirements=>{:role => /[a-z]/}
      response.should render_template(:edit)
      assigns(:user).should eq(@admin)
    end
  end
   
  describe "POST create" do
    describe "with valid params" do
      def do_post
        post :create, :user => Factory.attributes_for(:student), :role => "student", :requirements=>{:role => /[a-z]/}
      end
      
      it "should increment number of users by one" do
        proc { do_post }.should change(User, :count).by(1)
      end
   
   
      it "redirects to the created user" do
        do_post
        response.should redirect_to(admins_user_url(assigns(:user), :role => 'student', :anchor => "ui-tabs-1"))
      end
    end
   
    describe "with invalid params" do
      def do_post
        post :create, :user => Factory.attributes_for(:student, :first_name => "James$"), :role => "student", :requirements=>{:role => /[a-z]/}
      end
      
      it "assigns a newly created but unsaved user as @user" do
        proc{ do_post }.should_not change(User, :count)
      end
       
      it "re-renders the 'new' template" do
        do_post
        response.should render_template(:new)
      end
    end
  end
   
  describe "PUT update" do
    before(:each) do
      @user = Factory(:instructor)
    end
     
    describe "with valid params" do
      before(:each) do
        put :update, :id => @user.id, :user => { :first_name => "Joe" }, :role => "guest", :requirements=>{:role => /[a-z]/}
      end
       
      it { assigns(:user).should be_instance_of(User) }
      it { assigns(:user).should be_valid }
      it { response.should redirect_to(admins_user_url(@user, :role => "guest")) }
    end
       
    describe "with invalid params" do
      before(:each) do
        put :update, :id => @user.id, :user => { :first_name => "Jame$" }, :role => "guest", :requirements=>{:role => /[a-z]/}
      end
        
      it { assigns(:user).should be_instance_of(User) }
      it { assigns(:user).should_not be_valid }
      it { response.should render_template(:edit) }
    end
  end
   
  describe "DELETE destroy" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "destroys the requested user" do
      proc { delete :destroy, :id => @user.id, :role => "guest", :requirements=>{:role => /[a-z]/} }.should change(User, :count).by(-1)
      response.should redirect_to(admins_users_path(:role => @user.role))
    end
  end
end
