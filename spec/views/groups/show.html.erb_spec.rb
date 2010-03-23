require 'spec_helper'

describe "groups/show.html.erb" do
  before(:each) do
    assign(:group, @group = stub_model(Group,
      :name => "MyString",
      :code => "MyString",
      :instructor_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    response.should contain("MyString")
    response.should contain("MyString")
    response.should contain(1)
  end
end
