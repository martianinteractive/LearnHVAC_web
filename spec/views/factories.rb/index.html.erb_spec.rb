require 'spec_helper'

describe "users/index.html.erb" do
  include UsersHelper

  before(:each) do
    assign(:users, [
      stub_model(User,
        :login => "MyString",
        :email => "MyString",
        :first_name => "MyString",
        :last_name => "MyString",
        :institution_id => 1,
        :active => false,
        :student_id => 1
      ),
      stub_model(User,
        :login => "MyString",
        :email => "MyString",
        :first_name => "MyString",
        :last_name => "MyString",
        :institution_id => 1,
        :active => false,
        :student_id => 1
      )
    ])
  end

  it "renders a list of users" do
    render
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
