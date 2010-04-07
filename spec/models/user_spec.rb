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
    group = build_group(:instructor => user_with_role(:instructor))
    @user = user_with_role(:student, 1, { :group_code => group.code })
    @user.require_group_code!
    @user.should be_valid
  end
  
  it "should register an student as a member of the group's instructor institution" do
    group = build_group( :instructor => user_with_role(:instructor, 1, { :institution => Factory(:institution) }))
    @user = user_with_role(:student, 1, { :group_code => group.code })
    @user.should be_valid
    @user.save
    @user.reload.institution.should == group.instructor.institution
  end
  
  context "Group Register" do 
    before(:each) do
      @group = build_group(:instructor => user_with_role(:instructor, 1, { :institution => Factory(:institution) }))
      @user  = user_with_role(:student, 1, { :group_code => @group.code })
    end
  
    it "" do
      proc { @user.register_group! }.should change(Membership, :count).by(1)
    end
  
    it "" do
      proc { @user.register_group! }.should change(@user.reload.groups, :size).by(1)
    end
    
    it "should not register a student without group_code" do
      @user.group_code = nil
      proc { @user.register_group! }.should_not change(Membership, :count)
      proc { @user.register_group! }.should_not change(@user.reload.groups, :size)
    end
    
  end
  
  context "on Callbacks" do
    
    describe "on destroy" do
      before(:each) do
        build_group(:instructor => @user)
      end
      
      it "should description" do
        proc { @user.destroy }.should change(Group, :count).by(-1)
      end
    end
  end
  
  context "Roles" do
    it "" do
      User::ROLES.should have(5).roles
    end
  end
  
  # context "Scopes" do
  #   before(:each) do
  #     @student    = create_user_with_role(:student)
  #     @instructor = create_user_with_role(:instructor)
  #     @admin      = create_user_with_role(:admin)
  #   end
  #   
  #   context "instructor" do
  #     it "should return only instructors" do
  #       
  #     end
  #   end
  #   
  #   
  # end
  
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
