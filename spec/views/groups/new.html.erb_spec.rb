require 'spec_helper'

describe "groups/new.html.erb" do
  before(:each) do
    assign(:group, stub_model(Group,
      :new_record? => true,
      :name => "MyString",
      :code => "MyString",
      :instructor_id => 1
    ))
  end

  it "renders new group form" do
    render

    response.should have_selector("form", :action => groups_path, :method => "post") do |form|
      form.should have_selector("input#group_name", :name => "group[name]")
      form.should have_selector("input#group_code", :name => "group[code]")
      form.should have_selector("input#group_instructor_id", :name => "group[instructor_id]")
    end
  end
end
