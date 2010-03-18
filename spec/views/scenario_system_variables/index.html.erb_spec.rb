require 'spec_helper'

describe "scenario_variables/index.html.erb" do
  before(:each) do
    assign(:scenario_variables, [
      stub_model(ScenarioSystemVariable),
      stub_model(ScenarioSystemVariable)
    ])
  end

  it "renders a list of scenario_variables" do
    render
  end
end
