require 'spec_helper'

describe "scenario_system_variables/index.html.erb" do
  before(:each) do
    assign(:scenario_system_variables, [
      stub_model(ScenarioSystemVariable),
      stub_model(ScenarioSystemVariable)
    ])
  end

  it "renders a list of scenario_system_variables" do
    render
  end
end
