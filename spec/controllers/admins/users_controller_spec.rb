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
        mock_user(
          :role_code=   => "",
          :enabled=     => "",
          :save         => true,
          :has_role?    => true,
          :group_code=  => "",
          :group_code   => ""
        )
        User.stub(:new).with({'this' => 'params'}).and_return(mock_user)
        Group.stub_chain(:find_by_code, :create_memberships).and_return(mock_model(Membership))
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
        mock_user(:role_code= => "", :enabled= => "", :save => false, :group_code= => '')
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
end
