require 'spec_helper'

describe "colleges/edit.html.erb" do
  before(:each) do
    assign(:college, @college = stub_model(College,
      :new_record? => false,
      :value => "MyString"
    ))
  end

  it "renders the edit college form" do
    render

    response.should have_selector("form", :action => college_path(@college), :method => "post") do |form|
      form.should have_selector("input#college_value", :name => "college[value]")
    end
  end
end
