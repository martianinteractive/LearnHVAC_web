require File.dirname(__FILE__) + "/../../../spec_helper"

describe Admins::Settings::EducationalEntitiesController do
  let(:current_user) { Factory.stub(:admin) }

  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
  end
  
  def mock_college(stubs={})
    @mock_college ||= mock_model(College, stubs)
  end
  
  describe "GET search" do
    it "should expose colleges that match the query" do
      College.should_receive(:search).with('bla').and_return([mock_college])
      get :search, :q => 'bla'
      assigns[:colleges].should eq([mock_college])
    end
    
    it "should render the index template" do
      College.stub!(:search).and_return([mock_college])
      get :search, :q => 'bla'
      response.should render_template(:index)
    end
  end
  
  describe "GET index" do
    it "should expose colleges and render the template" do
      College.should_receive(:paginate).and_return([mock_college])
      get :index
      response.should render_template(:index)
      assigns[:colleges].should eq([mock_college])
    end
  end
  
  describe "GET show" do
    it "should expose college and render the show template" do
      College.should_receive(:find).with('37').and_return(mock_college({:value => 'bla'}))
      get :show, :id => '37'
      response.should render_template(:show)
      assigns[:college].should eq(mock_college)
    end
  end

  describe "GET new" do
    it "should expose a new instance of college and render the new template" do
      College.should_receive(:new).and_return(mock_college)
      get :new
      assigns[:college].should eq(mock_college)
      response.should render_template(:new)
    end
  end

  describe "GET edit" do
    it "should expose the college and render the edit template" do
      College.should_receive(:find).with('37').and_return(mock_college({:value => 'bla'}))
      get :edit, :id => '37'
      assigns[:college].should eq(mock_college)
      response.should render_template(:edit)
    end
  end

  describe "POST create" do
    describe "with valid attrs" do
      it "should expose the master college" do
        College.should_receive(:new).with('these' => 'params').and_return(mock_college({:save => true}))
        mock_college.should_receive(:save).and_return(:true)
        post :create, :college => {:these => 'params'}
        assigns[:college].should eq(mock_college)
      end

      it "should redirect to the master college" do
        College.stub!(:new).and_return(mock_college({:user= => current_user, :save => true}))
        post :create, :college => {}
        response.should redirect_to(admins_settings_educational_entity_path(assigns[:college]))
      end
    end

    describe "with invalid attrs" do
      it "should expose the college" do
        College.should_receive(:new).with('these' => 'params').and_return(mock_college({:save => false}))
        mock_college.should_receive(:save).and_return(:false)
        post :create, :college => {:these => 'params'}
        assigns[:college].should eq(mock_college)
      end

      it "should redirect to the college" do
        College.stub!(:new).and_return(mock_college({:save => false}))
        post :create, :college => {}
        response.should render_template(:new)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should expose the college" do
        College.should_receive(:find).with('37').and_return(mock_college({:update_attributes => true}))
        mock_college.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :college => {:these => 'params'}
        assigns[:college].should eq(mock_college)
      end

      it "should redirect to college" do
        College.stub!(:find).and_return(mock_college({:update_attributes => true}))
        put :update, :id => '37'
        response.should redirect_to(admins_settings_educational_entity_path(assigns[:college]))
      end
    end

    describe "with invalid params" do
      it "should expose the college" do
        College.should_receive(:find).with('37').and_return(mock_college({:update_attributes => false, :name => 'bla'}))
        mock_college.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :college => {:these => 'params'}
        assigns[:college].should eq(mock_college)
      end

      it "should redirect to college" do
        College.stub!(:find).and_return(mock_college({:name => 'bla', :update_attributes => false}))
        put :update, :id => '37'
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "should destroy the college" do
      College.should_receive(:find).with('37').and_return(mock_college({:destroy => false}))
      mock_college.should_receive(:destroy).and_return(true)
      delete :destroy, :id => '37'
    end

    it "should redirect to index" do
      College.stub!(:find).and_return(mock_college)
      delete :destroy, :id => '37'
      response.should redirect_to(admins_settings_educational_entities_path)
    end
  end
end
