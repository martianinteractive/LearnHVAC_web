require 'spec_helper'

describe "instructor_system_variables/new.html.erb" do
  before(:each) do
    assign(:instructor_system_variable, stub_model(InstructorSystemVariable,
      :new_record? => true
    ))
  end

  it "renders new instructor_system_variable form" do
    render

    response.should have_selector("form", :action => instructor_system_variables_path, :method => "post") do |form|
    end
  end
end
