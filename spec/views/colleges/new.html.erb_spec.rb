require 'spec_helper'

describe "colleges/new.html.erb" do
  before(:each) do
    assign(:college, stub_model(College,
      :new_record? => true,
      :value => "MyString"
    ))
  end

  it "renders new college form" do
    render

    response.should have_selector("form", :action => colleges_path, :method => "post") do |form|
      form.should have_selector("input#college_value", :name => "college[value]")
    end
  end
end
