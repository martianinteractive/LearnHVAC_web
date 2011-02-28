require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::ClientVersionsController do
  let(:current_user) { Factory.stub(:instructor) }
  let(:mock_client_version) { mock_model(ClientVersion) }
  
  before { controller.stub(:current_user).and_return(current_user) }
  
  describe "GET index" do
    before { ClientVersion.stub(:paginate).and_return([mock_client_version]) }
    
    it "should expose client versions" do
      get :index
      assigns[:client_versions].should eq([mock_client_version])
    end
    
    it "should paginate" do
      ClientVersion.should_receive(:paginate).and_return([mock_client_version])
      get :index
    end
    
    it "should render index" do
      get :index
      response.should render_template(:index)
    end
  end
end
