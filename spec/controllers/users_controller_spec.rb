# require File.dirname(__FILE__) + "/../spec_helper"
# 
# describe UsersController do
#   
#   before(:each) do
#     @user = Factory(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
#     login_as(@user)
#   end
#   
#   #This behaviour applies for all the actions.
#   describe "GET show" do
#     it "should not let an instructor to view other users" do
#       get :show, :id => "37"
#       response.should render_template(:show)
#       assigns(:user).should be(@user)
#     end
#     
#     it "should show the requested user if current_user is admin" do
#       user_logout
#       admin_login
#       User.expects(:find).with("37").returns(mock_user)
#       get :show, :id => "37"
#       response.should render_template(:show)
#       assigns(:user).should be(mock_user)
#     end
#   end
# 
#   describe "GET edit" do
#     it "" do
#       get :edit, :id => @user.id
#       response.should render_template(:edit)
#       assigns(:user).should be(@user)
#     end
#   end
#   
#   describe "PUT update" do    
#     describe "with valid params" do      
#       it "updates the requested user" do
#         put :update, :id => @user.id, :user => { :first_name => "Joe" }
#         assigns(:user).should == @user.reload
#         @user.first_name.should == "Joe"
#       end
#       
#       it "redirects to the user" do
#         put :update, :id => @user.id, :user => { :last_name => "Doex" }
#         response.should redirect_to(user_url(@user))
#       end
#     end
#       
#     describe "with invalid params" do  
#       it "should not update the user" do
#         put :update, :id => @user.id, :user => { :first_name => "Jame$", :last_name => "" }
#         @user.reload.name.should_not == "Jame$"
#       end
#       
#       it "re-renders the 'edit' template" do
#         put :update, :id => @user.id, :user => { :first_name => "Jame$", :last_name => "" }
#         response.should render_template('edit')
#       end
#     end
#   end
#   
#   describe "DELETE destroy" do
#     it "destroys the requested user" do
#       proc { delete :destroy, :id => @user.id }.should change(User, :count).by(-1)
#       response.should redirect_to(users_path)
#     end
#   end
#   
#   describe "Authentication" do
#     before(:each) do
#       user_logout
#     end
#     
#     it "should require an authenticated user for all actions" do
#       authorize_actions({:get => [:show, :edit], :put => [ :update ], :delete => [ :destroy ]}) do
#         response.should redirect_to(login_path)
#         flash[:notice].should == "You must be logged in to access this page"
#       end
#     end
#   end
#   
#   describe "Authorization" do
#     
#     describe "As instructor" do
#       it "should not show/update/edit/destroy other users" do
#         @user.role_code = User::ROLES[:instructor]
#         @user.save
#         authorize_actions({:get => [:show, :edit], :put => [ :update ], :delete => [ :destroy ]}) do
#           assigns(:user).should eq(@user)
#         end
#       end
#     end
#   end
#   
#   def mock_user(attrs = {})
#     @mock_user ||= Factory(:user, attrs)
#   end
# 
# end
