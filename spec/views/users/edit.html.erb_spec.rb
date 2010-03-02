require 'spec_helper'

describe "users/edit.html.erb" do
  include UsersHelper

  before(:each) do
    assign(:user, @user = stub_model(User,
      :new_record? => false,
      :login => "MyString",
      :email => "MyString",
      :first_name => "MyString",
      :last_name => "MyString",
      :institution_id => 1,
      :active => false,
      :student_id => 1
    ))
  end

  it "renders the edit user form" do
    render

    response.should have_selector("form", :action => user_path(@user), :method => "post") do |form|
      form.should have_selector("input#user_login", :name => "user[login]")
      form.should have_selector("input#user_email", :name => "user[email]")
      form.should have_selector("input#user_first_name", :name => "user[first_name]")
      form.should have_selector("input#user_last_name", :name => "user[last_name]")
      form.should have_selector("input#user_institution_id", :name => "user[institution_id]")
      form.should have_selector("input#user_active", :name => "user[active]")
      form.should have_selector("input#user_student_id", :name => "user[student_id]")
    end
  end
end
