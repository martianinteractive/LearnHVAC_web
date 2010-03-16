require File.dirname(__FILE__) + "/../spec_helper"

describe SystemVariable do
  
  context "Roles" do
    it "" do
      SystemVariable::TYPES.should have(3).types
    end
  end
end
