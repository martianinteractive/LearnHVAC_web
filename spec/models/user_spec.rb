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
    @user.errors[:first_name].should == ["can't be blank", "is invalid"]
    @user.errors[:last_name].should == ["can't be blank", "is invalid"]
  end
  
end
