require File.dirname(__FILE__) + "/../spec_helper"

describe SystemVariablesController do
  before(:each) do
    @instructor = Factory.build(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    @instructor.role_code = User::ROLES[:instructor]
    @instructor.save
    login_as(@instructor)
  end
  
  describe "GET index" do
    it "" do
      SystemVariable.expects(:all).returns([mock_instructor_var])
      get :index
      response.should render_template(:index)
      assigns(:system_variables).should eq([mock_instructor_var])
    end
  end
  
  describe "GET show" do
    it "" do
      SystemVariable.expects(:find).with("37").returns(mock_instructor_var)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:system_variable).should be(mock_instructor_var)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:system_variable).should be_instance_of(SystemVariable)
    end
  end
  
  describe "GET edit" do
    it "" do
      SystemVariable.expects(:find).with("37").returns(mock_instructor_var)
      get :edit, :id => "37"
      response.should render_template(:edit)
      assigns(:system_variable).should be(mock_instructor_var)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "should change the SystemVariable count" do
        proc{ post :create, :instructor_factory => Factory.attributes_for(:system_variable) }.should change(SystemVariable, :count).by(1)
      end
      
      it "should assign the current user as the SystemVariable user" do
        post :create, :system_variable => Factory.attributes_for(:system_variable)
        assigns(:system_variable).user.should == @instructor
        
      end
  
      it "redirects to the created system_variable" do
        post :create, :system_variable => Factory.attributes_for(:system_variable)
        response.should redirect_to(system_variable_path(assigns(:system_variable)))
      end
    end
  
    pending "Define invalid attrs for instructor system var"
    describe "with invalid params" do
    end
  end
  
  describe "PUT update" do
    
    before(:each) do
      @system_variable = Factory(:system_variable)
    end
    
    describe "with valid params" do      
      it "updates the requested system_variable" do
        put :update, :id => @system_variable.id, :system_variable => { :name => "Inst var" }
        @system_variable.reload["name"].should == "Inst var"
      end
      
      it "redirects to the system_variable" do
        put :update, :id => @system_variable.id, :system_variable => { :name => "Inst var" }
        response.should redirect_to(system_variable_path(@system_variable.id))
      end
    end
    
    pending "Define invalid attrs for  system var"
    describe "with invalid params" do  
    end
  end
  
  
  describe "DELETE destroy" do
    before(:each) do
      @system_variable = Factory(:system_variable)
    end
    
    it "destroys the requested system_variable" do
      proc { delete :destroy, :id => @system_variable.id }.should change(SystemVariable, :count).by(-1)
    end
  
    it "redirects to the system_variables list" do
      delete :destroy, :id => @system_variable.id
      response.should redirect_to(system_variables_path)
    end
  end
  
  describe "Authorization" do
    before(:each) do
      SystemVariable.stubs(:all).returns([mock_instructor_var])
      SystemVariable.stubs(:find).returns(mock_instructor_var)
    end
    
    describe "As " do
      it "should have access to all actions" do
        authorize_actions do
          flash[:notice].should_not == "You don't have the privileges to access this page"
        end
      end
    end
    
    describe "As Aadmin" do
      it "should have access to all actions" do
        @instructor.role_code = User::ROLES[:admin]
        @instructor.save
        authorize_actions do
          flash[:notice].should_not == "You don't have the privileges to access this page"
        end
      end
    end
    
    describe "As anything else" do
      it "should not have any access" do
        @instructor.role_code = User::ROLES[:student]
        @instructor.save
        authorize_actions do
          response.should redirect_to(users_path)
          response.body.should match(/redirected/)
          flash[:notice].should == "You don't have the privileges to access this page"
        end
      end
    end
  end
  
  
  def mock_instructor_var(attrs = {})
    @mock_system_variable ||= Factory(:system_variable, attrs)
  end
end
