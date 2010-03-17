require File.dirname(__FILE__) + "/../spec_helper"

describe InstructorSystemVariablesController do
  before(:each) do
    @instructor = Factory.build(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    @instructor.role_code = User::ROLES[:instructor]
    @instructor.save
    login_as(@instructor)
  end
  
  describe "GET index" do
    it "" do
      InstructorSystemVariable.expects(:all).returns([mock_instructor_var])
      get :index
      response.should render_template(:index)
      assigns(:instructor_system_variables).should eq([mock_instructor_var])
    end
  end
  
  describe "GET show" do
    it "" do
      InstructorSystemVariable.expects(:find).with("37").returns(mock_instructor_var)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:instructor_system_variable).should be(mock_instructor_var)
    end
  end
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:instructor_system_variable).should be_instance_of(InstructorSystemVariable)
    end
  end
  
  describe "GET edit" do
    it "" do
      InstructorSystemVariable.expects(:find).with("37").returns(mock_instructor_var)
      get :edit, :id => "37"
      response.should render_template(:edit)
      assigns(:instructor_system_variable).should be(mock_instructor_var)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "should change the InstructorSystemVariable count" do
        proc{ post :create, :instructor_system_factory => Factory.attributes_for(:instructor_system_variable) }.should change(InstructorSystemVariable, :count).by(1)
      end
      
      it "should assign the current user as the InstructorSystemVariable user" do
        post :create, :instructor_system_variable => Factory.attributes_for(:instructor_system_variable)
        assigns(:instructor_system_variable).user.should == @instructor
        
      end
  
      it "redirects to the created instructor_system_variable" do
        post :create, :instructor_system_variable => Factory.attributes_for(:instructor_system_variable)
        response.should redirect_to(instructor_system_variable_path(assigns(:instructor_system_variable)))
      end
    end
  
    pending "Define invalid attrs for instructor system var"
    describe "with invalid params" do
    end
  end
  
  describe "PUT update" do
    
    before(:each) do
      @instructor_system_variable = Factory(:instructor_system_variable)
    end
    
    describe "with valid params" do      
      it "updates the requested instructor_system_variable" do
        put :update, :id => @instructor_system_variable.id, :instructor_system_variable => { :name => "Inst var" }
        @instructor_system_variable.reload["name"].should == "Inst var"
      end
      
      it "redirects to the instructor_system_variable" do
        put :update, :id => @instructor_system_variable.id, :instructor_system_variable => { :name => "Inst var" }
        response.should redirect_to(instructor_system_variable_path(@instructor_system_variable.id))
      end
    end
    
    pending "Define invalid attrs for Instructor system var"
    describe "with invalid params" do  
    end
  end
  
  
  describe "DELETE destroy" do
    before(:each) do
      @instructor_system_variable = Factory(:instructor_system_variable)
    end
    
    it "destroys the requested instructor_system_variable" do
      proc { delete :destroy, :id => @instructor_system_variable.id }.should change(InstructorSystemVariable, :count).by(-1)
    end
  
    it "redirects to the instructor_system_variables list" do
      delete :destroy, :id => @instructor_system_variable.id
      response.should redirect_to(instructor_system_variables_path)
    end
  end
  
  describe "Authorization" do
    before(:each) do
      InstructorSystemVariable.stubs(:all).returns([mock_instructor_var])
      InstructorSystemVariable.stubs(:find).returns(mock_instructor_var)
    end
    
    describe "As Instructor" do
      it "should have access to all actions" do
        authorize_actions do
          flash[:notice].should_not == "You don't have the privileges to access this page"
        end
      end
    end
    
    describe "As Superadmin" do
      it "should have access to all actions" do
        @instructor.role_code = User::ROLES[:superadmin]
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
    @mock_instructor_variable ||= Factory(:instructor_system_variable, attrs)
  end
end
