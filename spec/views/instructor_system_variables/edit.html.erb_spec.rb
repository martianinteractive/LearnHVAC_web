require 'spec_helper'

describe "system_variables/edit.html.erb" do
  before(:each) do
    assign(:system_variable, @system_variable = stub_model(SystemVariable,
      :new_record? => false
    ))
  end

  it "renders the edit system_variable form" do
    render

    response.should have_selector("form", :action => system_variable_path(@system_variable), :method => "post") do |form|
    end
  end
end
