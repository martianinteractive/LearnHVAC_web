require 'spec_helper'

describe "system_variables/new.html.erb" do
  before(:each) do
    assign(:system_variable, stub_model(SystemVariable,
      :new_record? => true
    ))
  end

  it "renders new system_variable form" do
    render

    response.should have_selector("form", :action => system_variables_path, :method => "post") do |form|
    end
  end
end
