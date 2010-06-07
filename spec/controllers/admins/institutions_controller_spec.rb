require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::InstitutionsController do
  
  before(:each) do
    @institution = Factory(:institution, :name => "MI")
    admins_login
  end
  
  describe "GET index" do
    it "" do
      get :index
      response.should render_template(:index)
      assigns(:institutions).should_not be_empty
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
        response.should redirect_to(admins_institution_url(assigns(:institution)))
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
        response.should redirect_to(admins_institution_url(@institution))
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
      response.should redirect_to(admins_institutions_url)
    end
  end
  
  
  describe "Authentication" do
    before(:each) do
      @admin.role_code = User::ROLES[:student]
      @admin.save
    end
    
    it "should require an admin user for all actions" do
      authorize_actions do
        response.should redirect_to(default_path_for(@admin))
        flash[:notice].should == "You don't have privileges to access that page"
      end
    end
  end
  
  def mock_institution(attrs = {})
    @mock_institution ||= Factory(:institution, attrs)
  end

end
