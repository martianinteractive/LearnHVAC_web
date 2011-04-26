require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::InstitutionsController do
  let(:institution) { mock_model(Institution, :name => 'bla') }

  before(:each) do
    login_as(:admin)
  end

  context "GET index" do
    it "should expose institutions as @institutions and render the index template" do
      get :index
      response.should render_template(:index)
      assigns[:institution_grid].should_not be_nil
    end
  end

  describe "GET show" do
    it "should expose an institution as @institution and render the show template" do
      Institution.stub(:find).with("37").and_return(institution)
      institution.should_receive(:users).and_return([mock, mock])
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:institution).should be(institution)
    end
  end

  describe "GET new" do
    it "should instantiante a new institution and render the new template" do
      Institution.should_receive(:new).and_return(institution)
      get :new
      response.should render_template(:new)
    end
  end

  describe "GET edit" do
    it "" do
      Institution.stub(:find).with("37").and_return(institution)
      institution.should_receive(:name)
      get :edit, :id => "37"
      response.should render_template(:edit)
      assigns[:institution].should be(institution)
    end
  end


  describe "POST create" do
    describe "with valid params" do
      it "should create an institution" do
        Institution.should_receive(:new).with({'these' => 'params'}).and_return(institution)
        institution.should_receive(:save).and_return(:true)
        post :create, :institution => {:these => 'params'}
        assigns[:institution].should eq(institution)
      end

      it "redirects to the created institution" do
        Institution.stub!(:new).and_return(mock_model(Institution, :save => true))
        post :create, :group => {}
        response.should redirect_to(admins_institution_url(assigns(:institution)))
      end
    end

    describe "with invalid params" do
      let(:institution) { mock_model(Institution, :save => false) }

      it "should expose the institution" do
        Institution.stub!(:new).with('these' => 'params').and_return(institution)
        post :create, :institution => {:these => 'params'}
        assigns[:institution].should eq(institution)
      end

      it "re-renders the 'new' template" do
        Institution.stub!(:new).with('these' => 'params').and_return(institution)
        post :create, :institution => {:these => 'params'}
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do
    let(:institution) { mock_model(Institution, :update_attributes => true) }

    describe "with valid params" do
      it "should update the institution" do
        Institution.should_receive(:find).with('37').and_return(institution)
        institution.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :institution => { :these => 'params' }
      end

      it "should expose the requested institution" do
        Institution.stub!(:find).and_return(institution)
        put :update, :id => '1'
        assigns[:institution].should eq(institution)
      end

      it "should redirect to the institution" do
        Institution.stub!(:find).and_return(institution)
        put :update, :id => '1'
        response.should redirect_to(admins_institution_url(assigns[:institution]))
      end
    end

    describe "with invalid params" do
      let(:institution) { mock_model(Institution, :update_attributes => false, :name => 'bla') }

      it "should update the institution" do
        Institution.should_receive(:find).with('37').and_return(institution)
        institution.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :institution => { :these => 'params' }
      end

      it "should expose the requested institution" do
        Institution.stub!(:find).and_return(institution)
        put :update, :id => '1'
        assigns[:institution].should eq(institution)
      end

      it "should render the edit template" do
        Institution.stub!(:find).and_return(institution)
        institution.should_receive(:name)
        put :update, :id => '1'
        response.should render_template('edit')
      end
    end
  end
  
  describe "DELETE destroy" do
    let(:institution) { mock_model(Institution, :destroy => true) }
    
    it "should destroy the requested institution" do
      Institution.should_receive(:find).with('37').and_return(institution)
      institution.should_receive(:destroy)
      delete :destroy, :id => '37'
    end
    
    it "should redirect to the index" do
      Institution.stub!(:find).and_return(institution)
      delete :destroy, :id => '37'
      response.should redirect_to(admins_institutions_url)
    end
  end

end
