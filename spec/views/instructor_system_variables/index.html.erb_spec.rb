require 'spec_helper'

describe "instructor_system_variables/index.html.erb" do
  before(:each) do
    assign(:instructor_system_variables, [
      stub_model(InstructorSystemVariable),
      stub_model(InstructorSystemVariable)
    ])
  end

  it "renders a list of instructor_system_variables" do
    render
  end
end
