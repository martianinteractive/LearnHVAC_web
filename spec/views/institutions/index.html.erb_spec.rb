require 'spec_helper'

describe "institutions/index.html.erb" do
  before(:each) do
    assign(:institutions, [
      stub_model(Institution,
        :name => "MyString",
        :description => "MyText"
      ),
      stub_model(Institution,
        :name => "MyString",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of institutions" do
    render
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
