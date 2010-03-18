require 'spec_helper'

describe "scenario_variables/show.html.erb" do
  before(:each) do
    assign(:scenario_system_variable, @scenario_system_variable = stub_model(ScenarioSystemVariable)
  end

  it "renders attributes in <p>" do
    render
  end
end
