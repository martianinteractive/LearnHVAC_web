require File.dirname(__FILE__) + "/../spec_helper"

describe User do
  
  it { should belong_to(:institution) }
  it { should have_many(:created_scenarios).dependent(:destroy) }
  it { should have_many(:master_scenarios).dependent(:destroy) }
  it { should have_many(:managed_groups).dependent(:destroy) }
  it { should have_many(:group_memberships) }
  it { should have_many(:groups).through(:group_memberships) }
  it { should have_many(:group_scenarios).through(:group_memberships) }
  it { should have_many(:individual_memberships) }
  it { should have_many(:individual_scenarios).through(:individual_memberships) }
  
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:role_code) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:country) }
  
  context "new valid user" do
    subject { Factory.build(:guest) }
  
    it { should be_valid }
    its(:errors) { should be_empty }
    its(:first_name) { should eq('louis') }
    its(:role_code) { should eq(0) }
    its(:enabled) { should be_true }
    its(:active) { should be_true }
  end
  
  context "as new student without group_code should be invalid" do
    subject { Factory.build(:student, :group_code => "") }
    
    it { should be_invalid }
    it { should have(2).error_on(:group_code) }
  end
  
  context "as new student with non existing group_code" do
    subject { Factory.build(:student, :group_code => "madeupcode") }
    
    it { should be_invalid }
    it { should have(1).error_on(:group_code) }
  end
  
  context "as new studnet with valid group code" do
    let(:group) { Factory(:valid_group) }
    subject { Factory.build(:student, :group_code => group.code) }
    
    it { should be_valid }
  end
  
  context "as new user requiring acceptance of agreement" do
    let(:user) { Factory.build(:guest, :terms_agreement => '') }
    
    it "" do
      user.require_agreement_acceptance!
      user.should be_invalid
      user.should have(1).error_on(:terms_agreement)
    end
  end
  
  context "an inactive user can be activated" do
    let(:user) { Factory(:guest, :active => false) }
    
    it { expect {user.activate!}.to change(user, :active).from(false).to(true) }
  end
  
  context "a student registering for the first time with valid group code" do
    let(:group) { Factory(:valid_group, :creator => Factory(:ucla_user)) }
    subject { Factory(:student, :group_code => group.code) }
    
    its(:institution_name) { should == group.creator.institution_name }
    
  end
  
  
  context "Delivering emails" do
    let(:user) { Factory(:guest) }
    let(:email) { ActionMailer::Base.deliveries.first }

    before { ActionMailer::Base.deliveries = [] }
    
    it "should send password reset instructions with perishable token" do
      user.deliver_password_reset_instructions!
      email.subject.should match(/Password Reset Instructions/)
      email.body.should match(/#{user.perishable_token}/)
    end
    
    it "should send activation instructions with perishable token" do
      user.deliver_activation_instructions!
      email.subject.should match(/Activation Instructions/)
      email.body.should match(/#{user.perishable_token}/)
    end
    
    it "should send an activation confirmation email" do
      user.deliver_activation_confirmation!
      email.subject.should match(/Activation Confirmation/)
    end
  end
end
