require 'spec_helper'

describe "scenario_variables/new.html.erb" do
  before(:each) do
    assign(:scenario_system_variable, stub_model(ScenarioSystemVariable,
      :new_record? => true
    ))
  end

  it "renders new scenario_system_variable form" do
    render

    response.should have_selector("form", :action => scenario_variables_path, :method => "post") do |form|
    end
  end
end
