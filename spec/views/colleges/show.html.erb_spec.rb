require 'spec_helper'

describe "colleges/show.html.erb" do
  before(:each) do
    assign(:college, @college = stub_model(College,
      :value => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
    response.should contain("MyString")
  end
end
