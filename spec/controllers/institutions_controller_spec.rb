require 'spec_helper'

describe InstitutionsController do

  def mock_institution(stubs={})
    @mock_institution ||= mock_model(Institution, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all institutions as @institutions" do
      Institution.stub(:all) { [mock_institution] }
      get :index
      assigns(:institutions).should eq([mock_institution])
    end
  end

  describe "GET show" do
    it "assigns the requested institution as @institution" do
      Institution.stub(:find).with("37") { mock_institution }
      get :show, :id => "37"
      assigns(:institution).should be(mock_institution)
    end
  end

  describe "GET new" do
    it "assigns a new institution as @institution" do
      Institution.stub(:new) { mock_institution }
      get :new
      assigns(:institution).should be(mock_institution)
    end
  end

  describe "GET edit" do
    it "assigns the requested institution as @institution" do
      Institution.stub(:find).with("37") { mock_institution }
      get :edit, :id => "37"
      assigns(:institution).should be(mock_institution)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created institution as @institution" do
        Institution.stub(:new).with({'these' => 'params'}) { mock_institution(:save => true) }
        post :create, :institution => {'these' => 'params'}
        assigns(:institution).should be(mock_institution)
      end

      it "redirects to the created institution" do
        Institution.stub(:new) { mock_institution(:save => true) }
        post :create, :institution => {}
        response.should redirect_to(institution_url(mock_institution))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved institution as @institution" do
        Institution.stub(:new).with({'these' => 'params'}) { mock_institution(:save => false) }
        post :create, :institution => {'these' => 'params'}
        assigns(:institution).should be(mock_institution)
      end

      it "re-renders the 'new' template" do
        Institution.stub(:new) { mock_institution(:save => false) }
        post :create, :institution => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested institution" do
        Institution.should_receive(:find).with("37") { mock_institution }
        mock_institution.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :institution => {'these' => 'params'}
      end

      it "assigns the requested institution as @institution" do
        Institution.stub(:find) { mock_institution(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:institution).should be(mock_institution)
      end

      it "redirects to the institution" do
        Institution.stub(:find) { mock_institution(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(institution_url(mock_institution))
      end
    end

    describe "with invalid params" do
      it "assigns the institution as @institution" do
        Institution.stub(:find) { mock_institution(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:institution).should be(mock_institution)
      end

      it "re-renders the 'edit' template" do
        Institution.stub(:find) { mock_institution(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested institution" do
      Institution.should_receive(:find).with("37") { mock_institution }
      mock_institution.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the institutions list" do
      Institution.stub(:find) { mock_institution(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(institutions_url)
    end
  end

end
