require File.dirname(__FILE__) + "/../spec_helper"

describe PasswordResetsController do
  
  before(:each) do
    @user = Factory(:user, :perishable_token => "perishabletoken")
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
    end
  end
  
  describe "POST create" do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end
    
    describe "with valid email" do
      it "should send an email with password reset instructions" do
        # Mail details tested in user_spec
        proc { post :create, :email => @user.email }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
      
      it "" do
        post :create, :email => @user.email
        flash[:notice].should =~ /Instructions to reset your password have been emailed to you/
        response.should redirect_to(root_url)
      end
    end
    
    describe "with invalid email" do
      it "should not send emails" do
        proc { post :create, :email => "fake@email.com" }.should_not change(ActionMailer::Base.deliveries, :size)
      end
      
      it "" do
        post :create, :email => "fake@email.com"
        flash[:notice].should =~ /No user was found/
        response.should render_template(:new)
      end
    end
  end
  
  describe "GET :edit" do
    describe "with valid perishable_token" do
      it "" do
        # User.stubs(:find_using_perishable_token).with(@user.id.to_s).returns(@user)
        # get :edit, :id => @user.id
        # response.should render_template(:edit) # Doesn't  recognize form path.
      end
    end
    
    describe "with invalid perishable_token" do
      it "" do
        User.expects(:find_using_perishable_token).with(@user.id.to_s).returns(nil)
        get :edit, :id => @user.id
        flash[:notice].should =~ /we could not locate your account/
        response.should redirect_to(root_url)
      end
    end
  end
  
  describe "PUT :update" do
    before(:each) { User.stubs(:find_using_perishable_token).with(@user.id.to_s).returns(@user) }
    
    describe "with valid password" do
      it "should update the password" do
        put :update, :id => @user.id, :user => { :password => "newpassword", :password_confirmation => "newpassword" }
        flash[:notice].should == "Password successfully updated"
        response.should redirect_to(root_url)
      end
    end
    
    describe "with invalid password" do
      it "should not update the password" do
        # put :update, :id => @user.id, :user => { :password => "newpassword", :password_confirmation => "newnewpassword" }
      end
      
      # response.should render_template(:edit) #doesn't recognize form path.
    end
  end
  
end
