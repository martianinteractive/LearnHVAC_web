require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::InstructorsController do
  let(:current_user) { Factory.stub(:manager) }

  before { controller.stub(:current_user).and_return(current_user) }

  def mock_instructor(stubs={})
    @mock_instructor ||= mock_model(User, stubs)
  end

  context "GET index" do
    before { current_user.stub_chain(:institution, :users, :instructor, :paginate).and_return([mock_instructor]) }

    it "should exponse the instructors for that institution" do
      get :index
      assigns[:instructors].should eq([mock_instructor])
    end

    it "should render the index template" do
      get :index
      response.should render_template(:index)
    end
  end

  context "GET show" do
    it "should expose the instructor" do
      current_user.stub_chain(:institution, :users, :instructor, :find).and_return(mock_instructor)
      get :show, :id => '37'
      assigns[:instructor].should eq(mock_instructor)
    end
  end

  context "GET new" do
    it "should initialize a new user and expose it" do
      User.should_receive(:new).and_return(mock_instructor)
      get :new
      assigns[:instructor].should eq(mock_instructor)
    end

    it "should render the new template" do
      User.stub(:new).and_return(mock_instructor)
      get :new
      response.should render_template(:new)
    end
  end


  context "GET edit" do
    before { current_user.stub_chain(:institution, :users, :instructor, :find).and_return(mock_instructor) }

    it "should find the instructor and expose it" do
      get :edit, :id => "37"
      assigns[:instructor].should eq(mock_instructor)
    end

    it "should render the edit template" do
      get :edit, :id => "37"
      response.should render_template(:edit)
    end
  end

  context "POST create" do
    context "successfully" do
      before { mock_instructor(:institution= => nil, :role_code= => nil, :save => true) }

      it "should expose the new user" do
        User.should_receive(:new).and_return(mock_instructor)
        post :create, :user => {}
        assigns[:instructor].should eq(mock_instructor)
      end

      it "should redirect to the instructors page" do
        User.stub(:new).and_return(mock_instructor)
        post :create, :user => {}
        response.should redirect_to(managers_instructor_path(assigns[:instructor]))
        flash[:notice].should_not be_empty
      end
    end

    context "UNsuccessfuly" do
      before { mock_instructor(:institution= => nil, :role_code= => nil, :save => false) }

      it "should expose the new user" do
        User.should_receive(:new).and_return(mock_instructor)
        post :create, :user => {}
        assigns[:instructor].should eq(mock_instructor)
      end

      it "should render the new template" do
        User.stub(:new).and_return(mock_instructor)
        post :create, :user => {}
        response.should render_template(:new)
      end
    end
  end

  context "PUT update" do
    context "Successfuly" do
      before(:each) do
        mock_instructor(:update_attributes => true, :institution= => nil, :role_code= => nil)
        current_user.stub_chain(:institution, :users, :instructor, :find).and_return(mock_instructor)
      end

      it "should find and expose the instructor" do
        put :update, :id => "37", :user => {}
        assigns[:instructor].should eq(mock_instructor)
      end

      it "should redirect" do
        put :update, :id => "37", :user => {}
        response.should redirect_to(managers_instructor_path(assigns[:instructor]))
      end

      it "should display a flash" do
        put :update, :id => "37", :user => {}
        flash[:notice].should_not be_empty
      end
    end

    context "UNsuccessfully" do
      before(:each) do
        mock_instructor(:update_attributes => false, :institution= => nil, :role_code= => nil)
        current_user.stub_chain(:institution, :users, :instructor, :find).and_return(mock_instructor)
      end

      it "should expose the instructor" do
        put :update, :id => "37", :user => {}
        assigns[:instructor].should eq(mock_instructor)
      end

      it "should render edit template" do
        put :update, :id => "37", :user => {}
        response.should render_template(:edit)
      end
    end
  end

  context "DELETE destroy" do
    before { current_user.stub_chain(:institution, :users, :instructor, :find).and_return(mock_instructor) }

    it "should destroy" do
      mock_instructor.should_receive(:destroy).and_return(true)
      delete :destroy, :id => "1"
    end

    it "should redirect" do
      mock_instructor.stub(:destroy).and_return(true)
      delete :destroy, :id => "1"
      response.should redirect_to(managers_instructors_path)
    end
  end
end
