require File.dirname(__FILE__) + "/../spec_helper"

describe Scenario do
  
  before(:each) do
    @user = Factory(:user)
    @scenario = Factory.build(:scenario, :user => @user)
  end
  
  pending "Make real tests for this, atm getting problems with documents."
    
  context "Callbacks" do
  end
  
  def create_user_system_vars
    Factory.create(:system_variable, :name => "var 1", :user => @user)
    Factory.create(:system_variable, :name => "var 2", :user => @user)
    Factory.create(:system_variable, :name => "var 3", :user => @user)
  end
end
