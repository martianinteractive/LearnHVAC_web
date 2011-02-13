require File.dirname(__FILE__) + "/../spec_helper"

describe AccountsController do
  let(:user) { mock_model(User) }
  
  context "GET :new" do
    it "should expose a new account as @account" do
      User.should_receive(:new).and_return(user)
      get :new
      assigns[:account].should equal(user)
    end
  end
  
  context "Post :create" do
    let(:user) {mock_model(User, :save_without_session_maintenance => true, :deliver_activation_instructions! => true, :has_role? => true, :active= => false, :role_code= => nil, :require_agreement_acceptance! => true)}
    
    before(:each) do
      ActionMailer::Base.deliveries = []
    end
    
    context "a valid account" do
      it "should expose a newly created user as @account" do
        User.should_receive(:new).with({'these' => 'params'}).and_return(user)
        post :create, :user => {:these => 'params'}
        assigns(:account).should equal(user)
      end
      
      it "should assign a role" do
         User.stub!(:new).and_return(user)
         user.should_receive(:role_code=).with(2)
         post :create, :user => {:role_code => User::ROLES[:instructor]}
      end
      
      it "should redirect to the login action" do
        User.stub!(:new).and_return(user)
        post :create, :user => {}
        response.should redirect_to(login_path)
      end
      
      it "should send an activation information mail" do
        proc { post :create, :user => Factory.attributes_for(:user) }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end
    
    context "an invalid account" do
      let(:user) {mock_model(User, :save_without_session_maintenance => false, :deliver_activation_instructions! => true, :has_role? => true, :active= => false, :role_code= => nil, :require_agreement_acceptance! => true)}
      
      it "should expose a newly created but unsaved user as @account" do
        User.stub!(:new).with({'role_code' => '2'}).and_return(user)
        post :create, :user => {:role_code => '2'}
        assigns(:account).should equal(user)
      end
      
      it "should re-render the new template" do
        User.stub!(:new).with({'role_code' => '2'}).and_return(user)
        post :create, :user => {:role_code => '2'}
        response.should render_template('new')
      end     
    end
  end
  
  context "Get: colleges" do
    let(:colleges) { [mock_model(College, :value => "UCLA")] }
    
    it "should expose colleges as @colleges" do
      College.should_receive(:find).and_return(colleges)
      get :colleges, :term => 'UCLA'
      assigns[:colleges].should eq(colleges)
    end
    
    it "should render json" do
      College.stub(:find).and_return(colleges)
      get :colleges, :term => 'UCLA'
      response.body.should == "[\"UCLA\"]"
    end
  end
  
  context "Get: states" do
    let(:states) { [mock_model(Region)] }
    
    it "should expose states as @states" do
      Region.stub_chain(:where, :order => states)
      Region.should_receive(:where).with({:country => "US"})
      get :states, :state => 'United States'
      assigns[:states].should eq(states)
    end
    
    it "should render partial states" do
      Region.stub_chain(:where, :order => states)
      get :states, :state => "United States"
      response.should render_template('states')
    end
  end
  
end
