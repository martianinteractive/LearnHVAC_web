require 'spec_helper'

describe "global_system_variables/edit.html.erb" do
  before(:each) do
    assign(:global_system_variable, @global_system_variable = stub_model(GlobalSystemVariable,
      :new_record? => false
    ))
  end

  it "renders the edit global_system_variable form" do
    render

    response.should have_selector("form", :action => global_system_variable_path(@global_system_variable), :method => "post") do |form|
    end
  end
end
