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
  
  context "Callbacks" do
    context "on create when the user is instructor" do
      
      before(:each) do
        create_global_system_vars
        @instructor = Factory.build(:user, :first_name => "Jack")
        @instructor.role_code = User::ROLES[:instructor]
      end
            
      it "should create a set of instructor_variables" do
        GlobalSystemVariable.count.should be > 1
        proc { @instructor.save }.should change(SystemVariable, :count).by(GlobalSystemVariable.count)
      end
      
      it "should assign the system variables to the user" do
        @instructor.save
        SystemVariable.all.each { |isv| isv.user.should == @instructor } 
      end
      
      pending "check attribute per attribute copy."
    end
  end
  
  context "Roles" do
    it "" do
      User::ROLES.should have(4).roles
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
    
    it "should send activation instructions" do
      @user.deliver_activation_instructions!
      sent.subject.should match(/Activation Instructions/)
      sent.body.should match(/register\/#{@user.perishable_token}/)
    end
    
    it "should send an activation confirmation email" do
      @user.deliver_activation_confirmation!
      sent.subject.should match(/Activation Confirmation/)
      sent.body.should match(/account has been activated/)
    end
  end
  
  def sent
    ActionMailer::Base.deliveries.first
  end
  
  def create_global_system_vars
   Factory(:global_system_variable, :name => "var 1")
   Factory(:global_system_variable, :name => "var 2")
   Factory(:global_system_variable, :name => "var 3")
  end
  
end
