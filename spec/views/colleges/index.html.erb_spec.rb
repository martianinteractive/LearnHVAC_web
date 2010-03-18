require 'spec_helper'

describe "colleges/index.html.erb" do
  before(:each) do
    assign(:colleges, [
      stub_model(College,
        :value => "MyString"
      ),
      stub_model(College,
        :value => "MyString"
      )
    ])
  end

  it "renders a list of colleges" do
    render
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
