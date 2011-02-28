require File.dirname(__FILE__) + "/../../spec_helper"

describe Guests::DashboardController do
  let(:current_user) { Factory.stub(:guest) }
  let(:mock_client_version) { mock_model(ClientVersion) }
  
  before { controller.stub(:current_user).and_return(current_user) }
  
  describe "GET show" do
    before { ClientVersion.stub(:paginate).and_return([mock_client_version]) }
    
    it "should paginate client_versions" do
      ClientVersion.should_receive(:paginate).and_return([mock_client_version])
      get :show
    end
    
    it "should expose client_versions" do
      get :show
      assigns[:client_versions].should eq([mock_client_version])
    end
    
    it "should render the index template" do
      get :show
      response.should render_template(:show)
    end
  end
end
