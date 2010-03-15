require File.dirname(__FILE__) + "/../spec_helper"

describe ActivationsController do
  
  before(:each) do
    @user = Factory.build(:user, :perishable_token => "perishabletoken")
    @user.active = false
    @user.save
  end
  
  describe "GET new" do
    describe "a not active user" do
      it "" do
        get :new, :activation_code => @user.perishable_token
        response.should render_template(:new)
      end
    end
    
    describe "an already active user" do      
      it "should raise an exception" do
        @user.activate!
        proc { get :new, :activation_code => @user.perishable_token }.should raise_error(Exception)
      end
    end
  end
  
  describe "POST create" do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end
    
    describe "a not active user" do
      it "should activate the user" do
        @user.reload.active.should be(false)
        post :create, :id => @user.id
        @user.reload.active.should be(true)
      end
      
      it "should send an activation email" do
        # mail detailed specs in user_spec.
        proc { post :create, :id => @user.id }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
      
      pending "redirect to another action."
      
      it "should redirect_to ?" do
        # test redirect after setting up the new root.
      end
    end
    
    describe "an already active user" do
      before(:each) do
        @user.activate!
      end
      
      it "should raise an exception" do
        proc { post :create, :id => @user.id }.should raise_error(Exception)
      end
      
      it "should render :new if there are problems activating" do
        User.expects(:find).with("99").returns(@user)
        @user.expects("active?").returns(false)
        @user.expects("activate!").returns(false)
        post :create, :id => "99"
        response.should render_template(:new)
      end
    end
    
  end

end
