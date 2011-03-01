require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::UsersController do
  let(:current_user) { Factory.stub(:admin) }
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, {:name => ""}.merge(stubs))
  end
  
  before { controller.stub(:current_user).and_return(current_user) }
  
  context "GET index" do
    before do
      User.stub_chain(:where, :includes, :order, :paginate).and_return([mock_user])
    end
    
    it "should expose users" do
      get :index, :role => 'admin', :requirements=>{:role => /[a-z]/}
      assigns[:users].should eq([mock_user])
    end
    
    it "should render template" do
      get :index, :role => 'admin', :requirements=>{:role => /[a-z]/}
      response.should render_template(:index)
    end
  end
  
  context "POST search" do
    before do
      User.stub_chain(:search, :paginate).and_return([mock_user])
    end
    
    it "should expose users" do
      post :search, :q => "love", :role => 'admin', :requirements=>{:role => /[a-z]/} 
      assigns[:users].should eq([mock_user])
    end
    
    it "should render index template" do
      post :search, :q => "love", :role => 'admin', :requirements=>{:role => /[a-z]/} 
      response.should render_template(:index)
    end
  end
  
  context "POST filter" do
    before do
      User.stub_chain(:filter, :paginate).and_return([mock_user])
    end
    
    it "should expose user" do
      post :filter, :institution_id => "1", :role => 'instructor', :requirements=>{:role => /[a-z]/}
      assigns[:users].should eq([mock_user])
    end
    
    it "should render the index template" do
      post :filter, :institution_id => "1", :role => 'instructor', :requirements=>{:role => /[a-z]/}
      response.should render_template(:index)
    end
  end
  
  describe "GET show" do
    before { User.stub(:find).with('1').and_return(mock_user) }
    
    it "assigns the requested user as @user" do
      get :show, :id => "1", :role => 'admin', :requirements=>{:role => /[a-z]/}
      assigns[:user].should eq(mock_user)
    end
    
    it "should render the show tempalte" do
      get :show, :id => "1", :role => 'student', :requirements => { :role => /[a-z]/ }
      response.should render_template(:show)
    end
  end
  
  describe "GET edit" do
    before { User.stub(:find).with("1").and_return(mock_user) }
    
    it "assigns the requested user as @user" do
      get :edit, :id => "1", :role => 'admin', :requirements=>{:role => /[a-z]/}
      assigns[:user].should eq(mock_user)
    end
    
    it "should render the edit template" do
      get :edit, :id => "1", :role => 'admin', :requirements=>{:role => /[a-z]/}
      response.should render_template(:edit)
    end
  end
  
  describe "POST create" do
    describe "successfully" do
      before do
        mock_user(:role_code= => "", :enabled= => "", :save => true)
        User.stub(:new).with({'this' => 'params'}).and_return(mock_user)
      end
    
      it "should expose user" do
        post :create, :user => {:this => 'params'}, :role => "student", :requirements=>{:role => /[a-z]/}
        assigns[:user].should eq(mock_user)
      end
      
      it "should redirect" do
        post :create, :user => {:this => 'params'}, :role => "student", :requirements=>{:role => /[a-z]/}
        response.should redirect_to(admins_user_path(assigns[:user], :role => "student", :anchor => "ui-tabs-1"))
      end
    end
    
    describe "unsuccessfully" do
      before do
        mock_user(:role_code= => "", :enabled= => "", :save => false)
        User.stub(:new).with({'this' => 'params'}).and_return(mock_user)
      end
      
      it "should expose the user" do
        post :create, :user => {:this => 'params'}, :role => "student", :requirements=>{:role => /[a-z]/}
        assigns[:user].should eq(mock_user)
      end
      
      it "should render the new teplate" do
        post :create, :user => {:this => 'params'}, :role => "student", :requirements=>{:role => /[a-z]/}
        response.should render_template(:new)
      end
    end
  end
  
  describe "PUT update" do
    describe "successfully" do
      before do
        mock_user(:role_code= => "", :enabled= => "", :update_attributes => true)
        User.stub(:find).with('1').and_return(mock_user)
      end
      
      it "should expose user" do
        put :update, :id => "1", :user => { :first_name => "Joe" }, :role => "guest", :requirements=>{:role => /[a-z]/}
        assigns[:user].should eq(mock_user)
      end
      
      it "should redirect" do
        put :update, :id => "1", :user => { :first_name => "Joe" }, :role => "guest", :requirements=>{:role => /[a-z]/}
        response.should redirect_to(admins_user_path(assigns[:user], :role => "guest"))
      end
    end
    
    describe "unssuccessfully" do
      before do
        mock_user(:role_code= => "", :enabled= => "", :update_attributes => false)
        User.stub(:find).with('1').and_return(mock_user)
      end
      
      it "should expose user" do
        put :update, :id => "1", :user => { :first_name => "Joe" }, :role => "guest", :requirements=>{:role => /[a-z]/}
        assigns[:user].should eq(mock_user)
      end
      
      it "should render edit" do
        put :update, :id => "1", :user => { :first_name => "Joe" }, :role => "guest", :requirements=>{:role => /[a-z]/}
        response.should render_template(:edit)
      end
    end
  end
  
  describe "DELETE destroy" do
    before do
      mock_user(:destroy => true, :role => 'guest')
      User.stub(:find).with('1').and_return(mock_user)
    end
    
    it "should expose user" do
      delete :destroy, :id => '1', :role => "guest", :requirements=>{:role => /[a-z]/}
      assigns[:user].should eq(mock_user)
    end
    
    it "should delete" do
      mock_user.should_receive(:destroy).and_return(true)
      delete :destroy, :id => '1', :role => "guest", :requirements=>{:role => /[a-z]/}
    end
    
    it "should redirect" do
      delete :destroy, :id => '1', :role => "guest", :requirements=>{:role => /[a-z]/}
      response.should redirect_to(admins_users_path(:role => 'guest'))
    end
  end

  # describe "GET index" do
  #   before(:each) { get :index, :role => 'admin', :requirements=>{:role => /[a-z]/} }
  #     
  #   it { response.should render_template(:index) }
  #   it { assigns(:users).should == [@admin] }
  # end
  # 
  # describe "POST search" do
  #   before(:each) { post :search, :q => "love", :role => 'admin', :requirements=>{:role => /[a-z]/} }
  # 
  #   it { response.should render_template(:index) }
  #   it { assigns(:users).should == [@admin] }
  # end
  # 
  # describe "POST filter" do
  #   before(:each) do
  #     @institution = Factory(:institution)
  #     @instructor  = Factory(:instructor, :institution => @institution)
  #     @admin.update_attributes(:institution_id => @institution.id)
  #   end
  #   
  #   it "" do
  #     post :filter, :institution_id => @institution.id, :role => 'instructor', :requirements=>{:role => /[a-z]/}
  #     response.should render_template(:index)
  #     assigns(:users).should == [@instructor]
  #   end
  #   
  #   it "" do
  #     institution = Factory(:institution, :name => "The Killing Fields")
  #     post :filter, :institution_id => institution.id, :role => 'instructor', :requirements=>{:role => /[a-z]/}
  #     assigns(:users).should be_empty      
  #   end
  # end
  #  
  # describe "GET show" do
  #   it "assigns the requested user as @user" do
  #     get :show, :id => @admin.id, :role => 'admin', :requirements=>{:role => /[a-z]/}
  #     response.should render_template(:show)
  #     assigns(:user).should eq(@admin)
  #   end
  #   
  #   it "" do
  #     student = Factory(:student, :institution_name => "MIT")
  #     get :show, :id => student.id, :role => 'student', :requirements => { :role => /[a-z]/ }
  #     response.should render_template(:show)
  #   end
  # end
  # 
  # describe "GET new" do
  #   it "assigns a new user as @user" do
  #     get :new, :role => 'admin', :requirements=>{:role => /[a-z]/}
  #     response.should render_template(:new)
  #     assigns(:user).should be_instance_of(User)
  #   end
  # end
  #  
  # describe "GET edit" do
  #   it "assigns the requested user as @user" do
  #     get :edit, :id => @admin.id, :role => 'admin', :requirements=>{:role => /[a-z]/}
  #     response.should render_template(:edit)
  #     assigns(:user).should eq(@admin)
  #   end
  # end
  #  
  # describe "POST create" do
  #   describe "with valid params" do
  #     def do_post
  #       post :create, :user => Factory.attributes_for(:student), :role => "student", :requirements=>{:role => /[a-z]/}
  #     end
  #     
  #     it "should increment number of users by one" do
  #       proc { do_post }.should change(User, :count).by(1)
  #     end
  #  
  #  
  #     it "redirects to the created user" do
  #       do_post
  #       response.should redirect_to(admins_user_url(assigns(:user), :role => 'student', :anchor => "ui-tabs-1"))
  #     end
  #   end
  #  
  #   describe "with invalid params" do
  #     def do_post
  #       post :create, :user => Factory.attributes_for(:student, :first_name => "James$"), :role => "student", :requirements=>{:role => /[a-z]/}
  #     end
  #     
  #     it "assigns a newly created but unsaved user as @user" do
  #       proc{ do_post }.should_not change(User, :count)
  #     end
  #      
  #     it "re-renders the 'new' template" do
  #       do_post
  #       response.should render_template(:new)
  #     end
  #   end
  # end
  #  
  # describe "PUT update" do
  #   before(:each) do
  #     @user = Factory(:instructor)
  #   end
  #    
  #   describe "with valid params" do
  #     before(:each) do
  #       put :update, :id => @user.id, :user => { :first_name => "Joe" }, :role => "guest", :requirements=>{:role => /[a-z]/}
  #     end
  #      
  #     it { assigns(:user).should be_instance_of(User) }
  #     it { assigns(:user).should be_valid }
  #     it { response.should redirect_to(admins_user_url(@user, :role => "guest")) }
  #   end
  #      
  #   describe "with invalid params" do
  #     before(:each) do
  #       put :update, :id => @user.id, :user => { :first_name => "Jame$" }, :role => "guest", :requirements=>{:role => /[a-z]/}
  #     end
  #       
  #     it { assigns(:user).should be_instance_of(User) }
  #     it { assigns(:user).should_not be_valid }
  #     it { response.should render_template(:edit) }
  #   end
  # end
  #  
  # describe "DELETE destroy" do
  #   before(:each) do
  #     @user = Factory(:user)
  #   end
  #   
  #   it "destroys the requested user" do
  #     proc { delete :destroy, :id => @user.id, :role => "guest", :requirements=>{:role => /[a-z]/} }.should change(User, :count).by(-1)
  #     response.should redirect_to(admins_users_path(:role => @user.role))
  #   end
  # end
end
