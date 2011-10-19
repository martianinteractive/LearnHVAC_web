require File.dirname(__FILE__) + "/../spec_helper"

describe PasswordResetsController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, {:email => "test@test.com", :perishable_token => "abc123"}.merge(stubs))
  end

  context "GET new" do
    it "should render the new template" do
      get :new
      response.should render_template(:new)
    end
  end

  context "GET edit" do
    it "should find and expose @user" do
      User.should_receive(:find_using_perishable_token).with("abc123").and_return(mock_user)
      get :edit, :id => "abc123"
      assigns[:user] = mock_user
    end

    it "should render the edit template" do
      User.stub(:find_using_perishable_token).and_return(mock_user)
      get :edit, :id => mock_user.perishable_token
      response.should render_template(:edit)
    end

    context "without existing user" do
      it "should redirect to login path with a flash notice" do
        get :edit, :id => "abc"
        response.should redirect_to(login_path)
        flash[:notice].should_not be_empty
      end
    end
  end

  context "POST create" do
    context "successfuly" do
      it "should find and expose user" do
        mock_user(:deliver_password_reset_instructions! => true)
        User.should_receive(:find_by_email).with(mock_user.email).and_return(mock_user)
        post :create, :email => mock_user.email
        assigns[:user].should == mock_user
      end

      it "should deliver password reset instructions" do
        User.stub(:find_by_email).with(mock_user.email).and_return(mock_user)
        mock_user.should_receive(:deliver_password_reset_instructions!)
        post :create, :email => mock_user.email
      end

      it "should redirect to login path" do
        User.stub(:find_by_email).with(mock_user.email).and_return(mock_user)
        mock_user.stub(:deliver_password_reset_instructions! => true)
        post :create, :email => mock_user.email
        response.should redirect_to(login_path)
      end
    end

    context "UNsuccessfully" do
      it "should find and expose user as nil" do
        User.should_receive(:find_by_email).with(mock_user.email).and_return(nil)
        post :create, :email => mock_user.email
        assigns[:user].should be_nil
      end

      it "should render the new action" do
        User.should_receive(:find_by_email).with(mock_user.email).and_return(nil)
        post :create, :email => mock_user.email
        response.should render_template(:new)
      end

      it "should display a flash" do
        User.should_receive(:find_by_email).with(mock_user.email).and_return(nil)
        post :create, :email => mock_user.email
        flash[:notice].should_not be_empty
      end
    end
  end

    context "update" do
      context "succesfully" do
        it "should expose user" do
          mock_user(:save => true, :password= => 'bla', :password_confirmation= => 'bla', :role => :admin, :active => true)
          User.stub(:find_using_perishable_token).with('37').and_return(mock_user)
          put :update, :id => "37", :user => {}
          assigns[:user].should eq(mock_user)
        end

        it "should update the password" do
          mock_user(:save => true, :password= => 'bla', :password_confirmation= => 'bla', :role => :admin, :active => true)
          User.stub(:find_using_perishable_token).with('37').and_return(mock_user)
          mock_user.should_receive(:password=)
          mock_user.should_receive(:password_confirmation=)
          put :update, :id => "37", :user => {}
        end

        it "should redirect accordingly" do
          mock_user(:save => true, :password= => 'bla', :password_confirmation= => 'bla', :role => :admin, :active => true)
          User.stub(:find_using_perishable_token).with('37').and_return(mock_user)
          put :update, :id => "37", :user => {}
          response.should redirect_to(admins_dashboard_path)
        end
      end

      context "unsuccessfuly because it could not save" do
        it "should expose the user" do
          mock_user(:save => false, :password= => 'bla', :password_confirmation= => 'bla', :active => true)
          User.stub(:find_using_perishable_token).with('37').and_return(mock_user)
          put :update, :id => "37", :user => {}
          assigns[:user].should eq(mock_user)
        end

        it "should render the edit template and display a flash" do
          mock_user(:save => false, :password= => 'bla', :password_confirmation= => 'bla', :active => true)
          User.stub(:find_using_perishable_token).with('37').and_return(mock_user)
          put :update, :id => "37", :user => {}
          flash[:notice].should_not be_empty
          response.should render_template(:edit)
        end
      end
    end

end
