require 'spec_helper'

describe "system_variables/show.html.erb" do
  before(:each) do
    assign(:system_variable, @system_variable = stub_model(SystemVariable)
  end

  it "renders attributes in <p>" do
    render
  end
end
