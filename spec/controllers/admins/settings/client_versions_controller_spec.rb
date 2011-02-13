require File.dirname(__FILE__) + "/../../../spec_helper"

describe Admins::Settings::ClientVersionsController do
  let(:current_user) { Factory.stub(:admin) }
  
  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
  end
  
  def mock_client_version(stubs={})
    @mock_client_version ||= mock_model(ClientVersion, stubs)
  end
  
  describe "GET index" do
    it "should expose client versions and render the template" do
      ClientVersion.should_receive(:paginate).and_return([mock_client_version])
      get :index
      response.should render_template(:index)
      assigns[:client_versions].should eq([mock_client_version])
    end
  end
  
  describe "GET show" do
    it "should client version and render the show template" do
      ClientVersion.should_receive(:find).with('37').and_return(mock_client_version({:version => 'bla'}))
      get :show, :id => '37'
      response.should render_template(:show)
      assigns[:client_version].should eq(mock_client_version)
    end
  end
    
  describe "GET new" do
    it "should expose a new instance of client version and render the new template" do
      ClientVersion.should_receive(:new).and_return(mock_client_version)
      get :new
      assigns[:client_version].should eq(mock_client_version)
      response.should render_template(:new)
    end
  end

  describe "GET edit" do
    it "should expose the a new client version render the edit template" do
      ClientVersion.should_receive(:find).with('37').and_return(mock_client_version({:version => 'bla'}))
      get :edit, :id => '37'
      assigns[:client_version].should eq(mock_client_version)
      response.should render_template(:edit)
    end
  end

  describe "POST create" do
    describe "with valid attrs" do
      it "should expose the master client_version" do
        ClientVersion.should_receive(:new).with('these' => 'params').and_return(mock_client_version({:save => true}))
        mock_client_version.should_receive(:save).and_return(:true)
        post :create, :client_version => {:these => 'params'}
        assigns[:client_version].should eq(mock_client_version)
      end

      it "should redirect to the master client_version" do
        ClientVersion.stub!(:new).and_return(mock_client_version({:user= => current_user, :save => true}))
        post :create, :client_version => {}
        response.should redirect_to(admins_settings_client_version_url(assigns[:client_version]))
      end
    end

    describe "with invalid attrs" do
      it "should expose the client_version" do
        ClientVersion.should_receive(:new).with('these' => 'params').and_return(mock_client_version({:save => false}))
        mock_client_version.should_receive(:save).and_return(:false)
        post :create, :client_version => {:these => 'params'}
        assigns[:client_version].should eq(mock_client_version)
      end

      it "should redirect to the client_version" do
        ClientVersion.stub!(:new).and_return(mock_client_version({:save => false}))
        post :create, :client_version => {}
        response.should render_template(:new)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should expose the client_version" do
        ClientVersion.should_receive(:find).with('37').and_return(mock_client_version({:update_attributes => true}))
        mock_client_version.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :client_version => {:these => 'params'}
        assigns[:client_version].should eq(mock_client_version)
      end

      it "should redirect to client_version" do
        ClientVersion.stub!(:find).and_return(mock_client_version({:update_attributes => true}))
        put :update, :id => '37'
        response.should redirect_to(admins_settings_client_version_url(assigns[:client_version]))
      end
    end

    describe "with invalid params" do
      it "should expose the client_version" do
        ClientVersion.should_receive(:find).with('37').and_return(mock_client_version({:update_attributes => false, :name => 'bla'}))
        mock_client_version.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :client_version => {:these => 'params'}
        assigns[:client_version].should eq(mock_client_version)
      end

      it "should redirect to client_version" do
        ClientVersion.stub!(:find).and_return(mock_client_version({:name => 'bla', :update_attributes => false}))
        put :update, :id => '37'
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "should destroy the scenario" do
      ClientVersion.should_receive(:find).with('37').and_return(mock_client_version({:destroy => false}))
      mock_client_version.should_receive(:destroy).and_return(true)
      delete :destroy, :id => '37'
    end

    it "should redirect to index" do
      ClientVersion.stub!(:find).and_return(mock_client_version)
      delete :destroy, :id => '37'
      response.should redirect_to(admins_settings_client_versions_path)
    end
  end
end
