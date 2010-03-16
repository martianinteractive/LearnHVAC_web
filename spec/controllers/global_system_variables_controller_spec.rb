require 'spec_helper'

describe GlobalSystemVariablesController do

  def mock_global_system_variable(stubs={})
    @mock_global_system_variable ||= mock_model(GlobalSystemVariable, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all global_system_variables as @global_system_variables" do
      GlobalSystemVariable.stub(:all) { [mock_global_system_variable] }
      get :index
      assigns(:global_system_variables).should eq([mock_global_system_variable])
    end
  end

  describe "GET show" do
    it "assigns the requested global_system_variable as @global_system_variable" do
      GlobalSystemVariable.stub(:find).with("37") { mock_global_system_variable }
      get :show, :id => "37"
      assigns(:global_system_variable).should be(mock_global_system_variable)
    end
  end

  describe "GET new" do
    it "assigns a new global_system_variable as @global_system_variable" do
      GlobalSystemVariable.stub(:new) { mock_global_system_variable }
      get :new
      assigns(:global_system_variable).should be(mock_global_system_variable)
    end
  end

  describe "GET edit" do
    it "assigns the requested global_system_variable as @global_system_variable" do
      GlobalSystemVariable.stub(:find).with("37") { mock_global_system_variable }
      get :edit, :id => "37"
      assigns(:global_system_variable).should be(mock_global_system_variable)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created global_system_variable as @global_system_variable" do
        GlobalSystemVariable.stub(:new).with({'these' => 'params'}) { mock_global_system_variable(:save => true) }
        post :create, :global_system_variable => {'these' => 'params'}
        assigns(:global_system_variable).should be(mock_global_system_variable)
      end

      it "redirects to the created global_system_variable" do
        GlobalSystemVariable.stub(:new) { mock_global_system_variable(:save => true) }
        post :create, :global_system_variable => {}
        response.should redirect_to(global_system_variable_url(mock_global_system_variable))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved global_system_variable as @global_system_variable" do
        GlobalSystemVariable.stub(:new).with({'these' => 'params'}) { mock_global_system_variable(:save => false) }
        post :create, :global_system_variable => {'these' => 'params'}
        assigns(:global_system_variable).should be(mock_global_system_variable)
      end

      it "re-renders the 'new' template" do
        GlobalSystemVariable.stub(:new) { mock_global_system_variable(:save => false) }
        post :create, :global_system_variable => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested global_system_variable" do
        GlobalSystemVariable.should_receive(:find).with("37") { mock_global_system_variable }
        mock_global_system_variable.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :global_system_variable => {'these' => 'params'}
      end

      it "assigns the requested global_system_variable as @global_system_variable" do
        GlobalSystemVariable.stub(:find) { mock_global_system_variable(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:global_system_variable).should be(mock_global_system_variable)
      end

      it "redirects to the global_system_variable" do
        GlobalSystemVariable.stub(:find) { mock_global_system_variable(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(global_system_variable_url(mock_global_system_variable))
      end
    end

    describe "with invalid params" do
      it "assigns the global_system_variable as @global_system_variable" do
        GlobalSystemVariable.stub(:find) { mock_global_system_variable(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:global_system_variable).should be(mock_global_system_variable)
      end

      it "re-renders the 'edit' template" do
        GlobalSystemVariable.stub(:find) { mock_global_system_variable(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested global_system_variable" do
      GlobalSystemVariable.should_receive(:find).with("37") { mock_global_system_variable }
      mock_global_system_variable.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the global_system_variables list" do
      GlobalSystemVariable.stub(:find) { mock_global_system_variable(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(global_system_variables_url)
    end
  end

end
