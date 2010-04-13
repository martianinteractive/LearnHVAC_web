require File.dirname(__FILE__) + "/../spec_helper"

describe ClientVersion do
  before(:each) do
    @client_version = Factory(:client_version)
  end
  
  it "" do
    @client_version.should be_valid
  end
  
  it "" do
    client_version = Factory.build(:client_version)
    client_version.should_not be_valid
    client_version.errors[:version].should_not be_empty
    client_version.version = "0.99.87"
    client_version.should be_valid
  end
  
end
