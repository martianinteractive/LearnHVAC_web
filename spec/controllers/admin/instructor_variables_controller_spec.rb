require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::InstructorVariablesController do
  
  pending "Fix this to work as SystemVariablesController"
  # before(:each) do
  #   @instructor = Factory.build(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
  #   @instructor.role_code = User::ROLES[:instructor]
  #   @instructor.save
  #   @instructor_variable = Factory(:system_variable, :user => @instructor)
  #   admin_login
  # end
  # 
  # 
  # describe "GET index" do
  #   it "" do
  #     get :index, :user_id => @instructor.id
  #     response.should render_template(:index)
  #     assigns(:instructor_variables).should_not be_empty
  #   end
  # end
  # 
  # describe "GET show" do
  #   it "" do
  #     get :show, :user_id => @instructor.id, :id => @instructor_variable.id
  #     response.should render_template(:show)
  #     assigns(:instructor_variable).should eq(@instructor_variable)
  #   end
  # end
  # 
  # describe "GET new" do
  #   it "" do
  #     get :new, :user_id => @instructor.id, :id => @instructor_variable.id
  #     response.should render_template(:new)
  #     assigns(:instructor_variable).should be_instance_of(SystemVariable)
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "" do
  #     get :edit, :user_id => @instructor.id, :id => @instructor_variable.id
  #     response.should render_template(:edit)
  #     assigns(:instructor_variable).should eq(@instructor_variable)
  #   end
  # end
  # 
  # describe "POST create" do
  #   describe "with valid params" do
  #     it "should change the SystemVariable count" do
  #       proc{ post :create, :user_id => @instructor.id, :system_variable => Factory.attributes_for(:system_variable, :name => "nvar") }.should change(SystemVariable, :count).by(1)
  #     end
  #     
  #     it "should assign the current user as the SystemVariable user" do
  #       post :create, :user_id => @instructor.id, :system_variable => Factory.attributes_for(:system_variable, :name => "new var")
  #       assigns(:instructor_variable).user.should == @instructor        
  #     end
  # 
  #     it "redirects to the created system_variable" do
  #       post :create, :user_id => @instructor.id, :system_variable => Factory.attributes_for(:system_variable, :name => "new var")
  #       response.should redirect_to(admin_user_instructor_variable_path(@instructor, assigns(:instructor_variable)))
  #     end
  #   end
  # 
  #   pending "Define invalid attrs for instructor system var"
  #   describe "with invalid params" do
  #   end
  # end
  # 
  # describe "PUT update" do    
  #   describe "with valid params" do      
  #     it "updates the requested system_variable" do
  #       put :update, :user_id => @instructor.id, :id => @instructor_variable.id, :system_variable => { :name => "Inst var" }
  #       @instructor_variable.reload.name.should == "Inst var"
  #     end
  #     
  #     it "redirects to the system_variable" do
  #       put :update, :user_id => @instructor.id, :id => @instructor_variable.id, :system_variable => { :name => "Inst var" }
  #       response.should redirect_to(admin_user_instructor_variable_path(@instructor, @instructor_variable))
  #     end
  #   end
  #   
  #   pending "Define invalid attrs for  system var"
  #   describe "with invalid params" do  
  #   end
  # end
  # 
  # describe "DELETE destroy" do    
  #   it "destroys the requested system_variable" do
  #     proc { delete :destroy, :user_id => @instructor.id, :id => @instructor_variable.id }.should change(SystemVariable, :count).by(-1)
  #   end
  # 
  #   it "redirects to the system_variables list" do
  #     delete :destroy, :user_id => @instructor.id, :id => @instructor_variable.id
  #     response.should redirect_to(admin_user_instructor_variables_url(@instructor))
  #   end
  # end
  # 
  # describe "Authentication" do
  #   before(:each) do
  #     @admin.role_code = User::ROLES[:student]
  #     @admin.save
  #   end
  #   
  #   it "should require an admin user for all actions" do
  #     authorize_actions do
  #       response.should redirect_to(default_path_for(@admin))
  #       flash[:notice].should == "You don't have the privileges to access this page"
  #     end
  #   end
  # end

end
