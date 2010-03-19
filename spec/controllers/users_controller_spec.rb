require File.dirname(__FILE__) + "/../spec_helper"

describe UsersController do
  
  before(:each) do
    @admin = Factory(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    login_as(@admin)
  end
  
  describe "GET show" do
    it "assigns the requested user as @user" do
      User.expects(:find).with("37").returns(mock_user)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:user).should be(mock_user)
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
        response.should redirect_to(user_url(@user))
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
      response.should redirect_to(users_path)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      user_logout
    end
    
    it "should require an authenticated user for all actions" do
      authorize_actions do
        response.should redirect_to(new_user_session_url)
        flash[:notice].should == "You must be logged in to access this page"
      end
    end
  end
  
  def mock_user(attrs = {})
    @mock_user ||= Factory(:user, attrs)
  end

end
