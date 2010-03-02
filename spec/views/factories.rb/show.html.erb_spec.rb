require 'spec_helper'

describe "users/show.html.erb" do
  include UsersHelper
  before(:each) do
    assign(:user, @user = stub_model(User,
      :login => "MyString",
      :email => "MyString",
      :first_name => "MyString",
      :last_name => "MyString",
      :institution_id => 1,
      :active => false,
      :student_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    response.should contain("MyString")
    response.should contain("MyString")
    response.should contain("MyString")
    response.should contain("MyString")
    response.should contain(1)
    response.should contain(false)
    response.should contain(1)
  end
end
