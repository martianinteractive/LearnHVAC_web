require 'spec_helper'

describe "scenario_variables/edit.html.erb" do
  before(:each) do
    assign(:scenario_system_variable, @scenario_system_variable = stub_model(ScenarioSystemVariable,
      :new_record? => false
    ))
  end

  it "renders the edit scenario_system_variable form" do
    render

    response.should have_selector("form", :action => scenario_system_variable_path(@scenario_system_variable), :method => "post") do |form|
    end
  end
end
