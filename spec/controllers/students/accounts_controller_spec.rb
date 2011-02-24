require File.dirname(__FILE__) + "/../../spec_helper"

describe Students::AccountsController do
  
  describe "GET: new" do
    let(:group) { mock_model(Group, :code => 'abc123') }
    let(:user) { mock_model(Student, :save_without_session_maintenance => true) }
    
    it "should expose group as @group" do
      Group.should_receive(:find_by_code).with("abc123").and_return(group)
      get :new, :code => group.code
      assigns[:group].should eq(group)
    end
    
    it "should expose User as @account" do
      Group.stub(:find_by_code).and_return(group)
      User.should_receive(:new).with(:group_code => "abc123").and_return(user)
      get :new, :code => group.code
      assigns[:account].should == user
    end
    
    it "should render the new template" do
      Group.stub(:find_by_code).and_return(group)
      get :new, :code => group.code
      response.should render_template(:new)
    end
  end
  
  describe "POST :create" do
    let(:group) { mock_model(Group, :code => 'abc123') }

    context "succesfully" do
      let(:user) { mock_model(Student, :save_without_session_maintenance => true) }
      
      it "should expose User as @account" do
        User.should_receive(:new).and_return(user)
        post :create, :user => {}
        assigns[:account].should eq(user)
      end
    
      it "should redirect" do
        User.stub(:new).and_return(user)
        post :create, :user => {}
        response.should redirect_to(login_path)
      end
    end
    
    context "unsuccessfully" do
      let(:user) { mock_model(Student, :save_without_session_maintenance => false) }
      
      it "should expose User as @account" do
        User.should_receive(:new).and_return(user)
        post :create, :user => {}
        assigns[:account].should eq(user)
      end
      
      it "should render new" do
        User.stub(:new).and_return(user)
        post :create, :user => {}
        response.should render_template(:new)
      end
    end
  end
  
end
