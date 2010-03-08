require 'spec_helper'

describe "institutions/new.html.erb" do
  before(:each) do
    assign(:institution, stub_model(Institution,
      :new_record? => true,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new institution form" do
    render

    response.should have_selector("form", :action => institutions_path, :method => "post") do |form|
      form.should have_selector("input#institution_name", :name => "institution[name]")
      form.should have_selector("textarea#institution_description", :name => "institution[description]")
    end
  end
end
