require File.dirname(__FILE__) + "/../../spec_helper"

describe Directory::ScenariosController do
  let(:current_user) { Factory.stub(:instructor) }
  let(:mock_institution) { mock_model(Institution) }
  let(:mock_scenario) { mock_model(Scenario) }
  
  before { controller.stub(:current_user).and_return(current_user) }
  
  describe "GET :show" do
    before do
      Institution.stub(:find).with('37').and_return(mock_institution)
      mock_institution.stub_chain(:scenarios, :public, :find).and_return(mock_scenario)
    end
    
    it "should expose the institution and scenario" do
      get :show, :institution_id => "37", :id => "1"
      assigns[:institution].should eq(mock_institution)
      assigns[:scenario].should eq(mock_scenario)
    end
    
    it "should render template" do
      get :show, :institution_id => "37", :id => "1"
      response.should render_template(:show)
    end
  end
    
end
