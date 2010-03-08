require 'spec_helper'

describe "institutions/edit.html.erb" do
  before(:each) do
    assign(:institution, @institution = stub_model(Institution,
      :new_record? => false,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit institution form" do
    render

    response.should have_selector("form", :action => institution_path(@institution), :method => "post") do |form|
      form.should have_selector("input#institution_name", :name => "institution[name]")
      form.should have_selector("textarea#institution_description", :name => "institution[description]")
    end
  end
end
