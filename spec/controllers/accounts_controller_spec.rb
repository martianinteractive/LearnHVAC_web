require File.dirname(__FILE__) + "/../spec_helper"

describe AccountsController do
  render_views
  
  describe "GET :new" do
    it "" do
      get :new
      response.should render_template(:new)
    end
  end
  
  describe "POST :create" do
    before(:each) do
      @expected_instructor_redirect = instructors_signup_path
      @expected_guest_redirect = guests_signup_path
      @expected_student_redirect = students_signup_path
    end
    
    it "should redirect according to role" do
      post :create, :role => 'instructor'
      response.should redirect_to(@expected_instructor_redirect)
      post :create , :role => 'guest'
      response.should redirect_to(@expected_guest_redirect)
      post :create, :role => 'student'
      response.should redirect_to(@expected_student_redirect)
    end
    
    it "should render :new if an invalid role is given" do
      post :create, :role => 'admin'
      response.should render_template(:new)
      post :create
      response.should render_template(:new)
    end
  end
  
end
