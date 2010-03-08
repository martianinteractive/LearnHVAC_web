require File.dirname(__FILE__) + "/../spec_helper"

describe User do
  before(:each) do
    @user = Factory.build(:user)
  end
  
  it "" do
    @user.should be_valid
  end
  
  it "should not be valid without first_name and last_name" do
    @user = Factory.build(:user, :first_name => "", :last_name => "")
    @user.should_not be_valid
    @user.errors[:first_name].sort.should == ["can't be blank", "is invalid"]
    @user.errors[:last_name].sort.should == ["can't be blank", "is invalid"]
  end
  
  it "should only allow alphanumeric values for name" do
    @user = Factory.build(:user, :first_name => "James", :last_name => "Doe$")
    @user.should_not be_valid
    @user.errors[:first_name].should be_empty
    @user.errors[:last_name].should == ["is invalid"]
  end
  
  context "Roles" do
    it "" do
      User::ROLES.should have(5).roles
    end
  end
  
  context "Delivering emails" do
    before(:each) do
      @user.save
      ActionMailer::Base.deliveries = []
    end
    
    it "should send password reset instructions" do
      @user.deliver_password_reset_instructions!
      sent.subject.should match(/Password Reset Instructions/)
      sent.body.should match(/#{@user.perishable_token}/)
    end
    
  end
  
  def sent
    ActionMailer::Base.deliveries.first
  end
  
end
