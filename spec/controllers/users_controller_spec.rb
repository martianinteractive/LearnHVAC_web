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

end
