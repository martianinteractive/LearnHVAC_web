require 'spec_helper'

describe "system_variables/index.html.erb" do
  before(:each) do
    assign(:system_variables, [
      stub_model(SystemVariable),
      stub_model(SystemVariable)
    ])
  end

  it "renders a list of system_variables" do
    render
  end
end
