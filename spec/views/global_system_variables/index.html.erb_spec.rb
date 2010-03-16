require 'spec_helper'

describe "global_system_variables/index.html.erb" do
  before(:each) do
    assign(:global_system_variables, [
      stub_model(GlobalSystemVariable),
      stub_model(GlobalSystemVariable)
    ])
  end

  it "renders a list of global_system_variables" do
    render
  end
end
