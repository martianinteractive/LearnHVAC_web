require File.dirname(__FILE__) + "/../../spec_helper"

describe Students::AccountsController do
  describe "GET :new" do
    it "should assign as @account" do
      get :new
      response.should render_template(:new)      
      assigns(:account).should be_instance_of(User)
    end
  end
  
  describe "POST :create" do
    before(:each) do
      @group = Factory.build(:group, :name => "Class 01", :instructor => user_with_role(:instructor))
      @group.expects(:scenario_validator).returns(true) #skip scenarios assignment.
      @group.save
      ActionMailer::Base.deliveries = []
    end
    
    describe "a valid account" do
      it "should save an not-active account" do
        post :create, :user => Factory.attributes_for(:user, :group_code => @group.code)
        assigns(:account).active?.should_not be(true)
      end
      
      # here we ensure the saved user is an student.
      it "should save set the role as :student" do
        post :create, :user => Factory.attributes_for(:user, :group_code => @group.code)
        assigns(:account).role_code.should == User::ROLES[:student]
      end
      
      it "should send an activation information mail" do
        proc { post :create, :user => Factory.attributes_for(:user, :group_code => @group.code) }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
      
      it "should redirect to the login action" do
        post :create, :user => Factory.attributes_for(:user, :group_code => @group.code)
        flash[:notice].should match(/Your account has been created/)
        response.should redirect_to(login_path)
      end
      
      it "should create membership if a valid group code is given" do
        proc { post :create, :code => @group.code, :user => Factory.attributes_for(:user, :group_code => @group.code) }.should change(Membership, :count).by(1)
      end
      
      it "should assign the user to the group" do
        post :create, :code => @group.code, :user => Factory.attributes_for(:user, :group_code => @group.code)
        assigns(:account).groups.should eq([@group])
      end
      
    end
    
    describe "an invalid account" do
      it "" do
        post :create
        response.should render_template(:new)
      end
    end
  end
end
