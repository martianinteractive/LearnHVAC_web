require File.dirname(__FILE__) + "/../spec_helper"

describe InstitutionsController do
  
  before(:each) do
    @superadmin = Factory.build(:user, :login => "joedoe", :email => "jdoe@lhvac.com")
    @superadmin.role_code = User::ROLES[:superadmin]
    @superadmin.save
    login_as(@superadmin)
  end
  
  describe "GET index" do
    it "" do
      Institution.expects(:all).returns([mock_institution])
      get :index
      response.should render_template(:index)
      assigns(:institutions).should eq([mock_institution])
    end
  end
  
  describe "GET show" do
    it "" do
      Institution.expects(:find).with("37").returns(mock_institution)
      get :show, :id => "37"
      response.should render_template(:show)
      assigns(:institution).should be(mock_institution)
    end
  end
  
  
  describe "GET new" do
    it "" do
      get :new
      response.should render_template(:new)
      assigns(:institution).should be_instance_of(Institution)
    end
  end
  
  
  describe "GET edit" do
    it "" do
      Institution.expects(:find).with("37").returns(mock_institution)
      get :edit, :id => "37"
      response.should render_template(:edit)
      assigns(:institution).should be(mock_institution)
    end
  end
  
  
  describe "POST create" do
    describe "with valid params" do
      it "should change the Institutions count" do
        proc{ post :create, :institution => Factory.attributes_for(:institution) }.should change(Institution, :count).by(1)
      end
  
      it "redirects to the created institution" do
        post :create, :institution => Factory.attributes_for(:institution)
        response.should redirect_to(institution_url(assigns(:institution)))
      end
    end
  
    describe "with invalid params" do
      it "should not change the Institution count" do
        proc{ post :create, :institution => Factory.attributes_for(:institution).merge(:name => "") }.should_not change(Institution, :count)
      end
      
      it "re-renders the 'new' template" do
        post :create, :institution => Factory.attributes_for(:institution).merge(:name => "")
        response.should render_template('new')
      end
    end
  end
  
  describe "PUT update" do
    
    before(:each) do
      @institution = Factory(:institution)
    end
    
    describe "with valid params" do      
      it "updates the requested institution" do
        put :update, :id => @institution.id, :institution => { :name => "Joe's Bar" }
        assigns(:institution).should == @institution.reload
        @institution.name.should == "Joe's Bar"
      end
      
      it "redirects to the Institution" do
        put :update, :id => @institution.id, :institution => { :name => "Joe's Bar" }
        response.should redirect_to(institution_url(@institution))
      end
    end
      
    describe "with invalid params" do  
      it "not update the institution" do
        put :update, :id => @institution.id, :institution => { :name => "" }
        assigns(:institution).should_not equal(@institution.reload)
      end
      
      it "re-renders the 'edit' template" do
        put :update, :id => @institution.id, :institution => { :name => "" }
        response.should render_template('edit')
      end
    end
  end
  
  
  describe "DELETE destroy" do
    
    before(:each) do
      @institution = Factory(:institution)
    end
    
    it "destroys the requested institution" do
      proc { delete :destroy, :id => @institution.id }.should change(Institution, :count).by(-1)
    end
  
    it "redirects to the institutions list" do
      delete :destroy, :id => @institution.id
      response.should redirect_to(institutions_url)
    end
  end
  
  
  describe "Authentication" do
    before(:each) do
      @superadmin.role_code = User::ROLES[:guest]
      @superadmin.save
    end
    
    it "should require a superadmin user for all actions" do
      authorize_actions do
        response.should redirect_to(root_path)
        flash[:notice].should == "You don't have the privileges to access this page"
      end
    end
  end
  
  def mock_institution(attrs = {})
    @mock_institution ||= Factory(:institution, attrs)
  end

end
