require 'spec_helper'

describe "institutions/show.html.erb" do
  before(:each) do
    assign(:institution, @institution = stub_model(Institution,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    response.should contain("MyString")
    response.should contain("MyText")
  end
end
