require 'spec_helper'

describe "instructor_system_variables/show.html.erb" do
  before(:each) do
    assign(:instructor_system_variable, @instructor_system_variable = stub_model(InstructorSystemVariable)
  end

  it "renders attributes in <p>" do
    render
  end
end
