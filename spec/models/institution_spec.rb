require File.dirname(__FILE__) + "/../spec_helper"

describe Institution do
  before(:each) do
    @institution = Factory.build(:institution)
  end
  
  it "" do
    @institution.should be_valid
  end
  
  it "" do
    Institution::CATEGORIES.should have(4).categories
  end
  
  it "should not be valid without name" do
    @institution.name = ""
    @institution.should_not be_valid
    @institution.errors[:name].sort.should == ["can't be blank"]
  end
  
  describe "Destroy" do
    before(:each) do
      @institution.users << Factory(:user, :login => "james", :email => "james@lhvac.com")
      @institution.users << Factory(:user, :login => "joe", :email => "joe@lhvac.com")
      @institution.save
    end
    
    it "should destroy the associated users" do
      proc { @institution.destroy }.should change(User, :count).by(-2)
    end
  end
  
end
