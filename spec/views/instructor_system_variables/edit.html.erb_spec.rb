require 'spec_helper'

describe "instructor_system_variables/edit.html.erb" do
  before(:each) do
    assign(:instructor_system_variable, @instructor_system_variable = stub_model(InstructorSystemVariable,
      :new_record? => false
    ))
  end

  it "renders the edit instructor_system_variable form" do
    render

    response.should have_selector("form", :action => instructor_system_variable_path(@instructor_system_variable), :method => "post") do |form|
    end
  end
end
