require 'spec_helper'

describe "global_system_variables/new.html.erb" do
  before(:each) do
    assign(:global_system_variable, stub_model(GlobalSystemVariable,
      :new_record? => true
    ))
  end

  it "renders new global_system_variable form" do
    render

    response.should have_selector("form", :action => global_system_variables_path, :method => "post") do |form|
    end
  end
end
