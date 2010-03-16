require 'spec_helper'

describe "global_system_variables/show.html.erb" do
  before(:each) do
    assign(:global_system_variable, @global_system_variable = stub_model(GlobalSystemVariable)
  end

  it "renders attributes in <p>" do
    render
  end
end
