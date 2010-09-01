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
  
  it "should not be valid if group_code is required and code is not present or invalid" do
    @user.require_group_code!
    @user.should_not be_valid
    @user.group_code = "fakecode"
    @user.should_not be_valid
  end
  
  it "should be valid if group_code is required and code is valid" do
    group = build_group(:creator => Factory(:instructor))
    @user = Factory(:student, :group_code => group.code)
    @user.require_group_code!
    @user.should be_valid
  end
  
  it "should register an student as a member of the group's instructor institution" do
    group = build_group( :creator => Factory(:instructor, :institution => Factory(:institution)))
    @user = Factory(:student, :group_code => group.code)
    @user.should be_valid
    @user.save
    @user.reload.institution.should == group.creator.institution
  end
  
  describe "finders" do
    before(:each) do
      @killing_fields = Factory(:institution, :name => "The Killing Fields")
      @big_oak        = Factory(:institution, :name => "The Big Oak")
      @toby  = Factory(:instructor, :first_name => "toby", :last_name => "doe", :login => "tobydoe", :email => "toby@lhvac.org", :institution => @killing_fields)
      @bob   = Factory(:instructor, :first_name => "bob", :last_name => "doe", :login => "bobdoe", :email => "bob@lhvac.org", :institution => @big_oak)
      @bubba = Factory(:student, :first_name => "buba", :last_name => "doe", :login => "bubbadoe", :email => "bubba@lhvac.org", :state => "west virginia", :institution => @killing_fields)
    end
    
    describe ".search" do
      it "should find users based on role" do
        users = User.search(User::ROLES[:instructor], "doe")
        users.should have(2).users
        users.should == [@toby, @bob]
        users = User.search(User::ROLES[:student], "doe")
        users.should have(1).user
        users.should == [@bubba]
      end

      it "should only find users by name, login or email" do
        users = User.search(User::ROLES[:student], "virginia")
        users.should be_empty
      end
    end
    
    describe ".filter" do
      it "should filter users based on role and institution" do
        users = User.filter(User::ROLES[:instructor], @killing_fields.id)
        users.should have(1).user
        users.should == [@toby]
        users = User.filter(User::ROLES[:instructor], @big_oak.id)
        users.should have(1).user
        users.should == [@bob]
        users = User.filter(User::ROLES[:student], @killing_fields.id)
        users.should have(1).user
        users.should == [@bubba]
        users = User.filter(User::ROLES[:student], @big_oak.id)
        users.should be_empty
      end
    end
  end
  
  context "on Callbacks" do    
    describe "on destroy" do
      before(:each) do
        build_group(:creator => @user)
      end
      
      it "should description" do
        proc { @user.destroy }.should change(Group, :count).by(-1)
      end
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
  
  def build_group(atts)
    group = Factory.build(:group, atts)
    group.expects("valid?").returns(true)
    group.save
    group
  end

  
end
