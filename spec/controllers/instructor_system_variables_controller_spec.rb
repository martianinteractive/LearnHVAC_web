require 'spec_helper'

describe InstructorSystemVariablesController do

  def mock_instructor_system_variable(stubs={})
    @mock_instructor_system_variable ||= mock_model(InstructorSystemVariable, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all instructor_system_variables as @instructor_system_variables" do
      InstructorSystemVariable.stub(:all) { [mock_instructor_system_variable] }
      get :index
      assigns(:instructor_system_variables).should eq([mock_instructor_system_variable])
    end
  end

  describe "GET show" do
    it "assigns the requested instructor_system_variable as @instructor_system_variable" do
      InstructorSystemVariable.stub(:find).with("37") { mock_instructor_system_variable }
      get :show, :id => "37"
      assigns(:instructor_system_variable).should be(mock_instructor_system_variable)
    end
  end

  describe "GET new" do
    it "assigns a new instructor_system_variable as @instructor_system_variable" do
      InstructorSystemVariable.stub(:new) { mock_instructor_system_variable }
      get :new
      assigns(:instructor_system_variable).should be(mock_instructor_system_variable)
    end
  end

  describe "GET edit" do
    it "assigns the requested instructor_system_variable as @instructor_system_variable" do
      InstructorSystemVariable.stub(:find).with("37") { mock_instructor_system_variable }
      get :edit, :id => "37"
      assigns(:instructor_system_variable).should be(mock_instructor_system_variable)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created instructor_system_variable as @instructor_system_variable" do
        InstructorSystemVariable.stub(:new).with({'these' => 'params'}) { mock_instructor_system_variable(:save => true) }
        post :create, :instructor_system_variable => {'these' => 'params'}
        assigns(:instructor_system_variable).should be(mock_instructor_system_variable)
      end

      it "redirects to the created instructor_system_variable" do
        InstructorSystemVariable.stub(:new) { mock_instructor_system_variable(:save => true) }
        post :create, :instructor_system_variable => {}
        response.should redirect_to(instructor_system_variable_url(mock_instructor_system_variable))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved instructor_system_variable as @instructor_system_variable" do
        InstructorSystemVariable.stub(:new).with({'these' => 'params'}) { mock_instructor_system_variable(:save => false) }
        post :create, :instructor_system_variable => {'these' => 'params'}
        assigns(:instructor_system_variable).should be(mock_instructor_system_variable)
      end

      it "re-renders the 'new' template" do
        InstructorSystemVariable.stub(:new) { mock_instructor_system_variable(:save => false) }
        post :create, :instructor_system_variable => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested instructor_system_variable" do
        InstructorSystemVariable.should_receive(:find).with("37") { mock_instructor_system_variable }
        mock_instructor_system_variable.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :instructor_system_variable => {'these' => 'params'}
      end

      it "assigns the requested instructor_system_variable as @instructor_system_variable" do
        InstructorSystemVariable.stub(:find) { mock_instructor_system_variable(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:instructor_system_variable).should be(mock_instructor_system_variable)
      end

      it "redirects to the instructor_system_variable" do
        InstructorSystemVariable.stub(:find) { mock_instructor_system_variable(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(instructor_system_variable_url(mock_instructor_system_variable))
      end
    end

    describe "with invalid params" do
      it "assigns the instructor_system_variable as @instructor_system_variable" do
        InstructorSystemVariable.stub(:find) { mock_instructor_system_variable(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:instructor_system_variable).should be(mock_instructor_system_variable)
      end

      it "re-renders the 'edit' template" do
        InstructorSystemVariable.stub(:find) { mock_instructor_system_variable(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested instructor_system_variable" do
      InstructorSystemVariable.should_receive(:find).with("37") { mock_instructor_system_variable }
      mock_instructor_system_variable.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the instructor_system_variables list" do
      InstructorSystemVariable.stub(:find) { mock_instructor_system_variable(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(instructor_system_variables_url)
    end
  end

end
