require File.dirname(__FILE__) + "/../spec_helper"

describe ActivationsController do
  let(:user) { mock_model(User, :active? => false) }

  context "GET New" do
    context "for inactive user" do
      it "should expose a user as @user" do
        User.should_receive(:find_using_perishable_token).with('abc123', 1.week).and_return(user)
        get :new, :activation_code => 'abc123'
        assigns[:user].should eq(user)
      end

      it "should render the new template" do
        User.stub(:find_using_perishable_token).and_return(user)
        get :new, :activation_code => 'abc123'
        response.should render_template(:new)
      end

      it "should redirect to login page with flash message" do
        User.stub(:find_using_perishable_token).and_return(nil)
        get :new, :activation_code => 'abc123'
        response.should redirect_to(login_path)
        flash[:notice].should eq('Unable to find your account')
      end
    end

    context "for active user" do
      let(:user) { mock_model(User, :active? => true) }

      it "should redirect to the login page" do
        User.stub(:find_using_perishable_token).and_return(user)
        get :new, :activation_code => 'abc123'
        response.should redirect_to(login_path)
        flash[:notice].should eq('Your account is already active')
      end
    end
  end

  context "POST create" do
    context "for an inactive user" do
      it "should expose the user as @user" do
        User.should_receive(:find).with('37').and_return(user)
        user.stub(:activate!)
        post :create, :id => '37'
        assigns[:user].should eq(user)
      end

      it "should instruct to activate the user" do
        User.stub(:find).with('37').and_return(user)
        user.should_receive(:activate!)
        post :create, :id => '37'
      end

      it "should instruct to deliver activation confirmation" do
        User.stub(:find).with('37').and_return(user)
        user.stub(:activate!).and_return(true)
        user.should_receive(:deliver_activation_confirmation!)
        post :create, :id => '37'
      end

      it "should deliver activation email" do
        user = Factory.build(:user, :perishable_token => "perishabletoken")
        user.active = false
        user.save
        proc { post :create, :id => user.id }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end

      context "that cannot be activated" do
        it "should render the new template" do
          User.stub(:find).with('37').and_return(user)
          user.stub(:activate!).and_return(false)
          post :create, :id => '37'
          response.should render_template('new')
        end
      end
    end

    context "for an active user" do
      let(:user) { mock_model(User, :active? => true) }

      it "should redirect to the login page with a flash notice" do
        User.should_receive(:find).with('37').and_return(user)
        user.stub(:activate!)
        post :create, :id => '37'
        response.should redirect_to(login_path)
        flash[:notice].should eq('Your account is alredy active')
      end
    end

    context "for a user that cannot be found" do

      it "should redirect to the login page with a flash notice" do
        User.should_receive(:find).with('37').and_return(nil)
        post :create, :id => '37'
        response.should redirect_to(login_path)
        flash[:notice].should eq('Unable to find your account')
      end
    end
  end

end
