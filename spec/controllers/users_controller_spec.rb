require File.dirname(__FILE__) + "/../spec_helper"

describe UsersController do

  let(:current_user) { Factory(:user) }

  before { controller.stub!(:current_user).and_return(current_user) }

  describe "GET profile" do
    it "" do
      get :show
      response.should render_template(:show)
    end
  end

  describe "GET edit" do
    it "" do
      get :edit, :id => current_user.id
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should redirect to profile_path" do
        put :update, :id => current_user.id, :user => { :last_name => "Doex" }
        response.should redirect_to(profile_path)
      end
    end

    describe "with invalid params" do
      it "should render the 'edit' template" do
        put :update, :id => current_user.id, :user => { :first_name => "Jame$", :last_name => "" }
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE destroy" do

    it "should destroy user session" do
      delete :destroy
      session.should be_empty
    end

    it "should delete user account" do
      expect { delete :destroy }.to change(User, :count).by(-1)
    end

    it "should redirect to the login form" do
      delete :destroy
      response.should redirect_to(login_path)
    end

  end

end
