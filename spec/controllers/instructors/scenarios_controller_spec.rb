require File.dirname(__FILE__) + "/../../spec_helper"

describe Instructors::ScenariosController do

  let(:current_user) { Factory.stub(:instructor) }

  before(:each) do
    controller.stub!(:current_user).and_return(current_user)
  end

  def mock_scenario(stubs={})
    @mock_scenario ||= mock_model(Scenario, {:name => ""}.merge(stubs))
  end

  context "an instructor tries to alter another instructor's scenario" do

    before do
      instructor = Factory(:instructor, :first_name => 'John', :last_name => 'Doe')
      Scenario.stub!(:find).and_return(mock_scenario(:user => instructor, :belongs_to_user? => false))
    end

    describe "GET 'edit'" do
      it "should redirect with flash message" do
        get :edit, :id => '42'
        response.should redirect_to(instructors_scenarios_path)
        flash[:warning].should eq('You are not allowed to access to that scenario.')
      end
    end

    describe "POST 'update'" do
      it "should redirect with flash message" do
        post :update, :id => '42'
        response.should redirect_to(instructors_scenarios_path)
        flash[:warning].should eq('You are not allowed to access to that scenario.')
      end
    end

    describe "DELETE 'destroy'" do
      it "should redirect with flash message" do
        delete :destroy, :id => '42'
        response.should redirect_to(instructors_scenarios_path)
        flash[:warning].should eq('You are not allowed to access to that scenario.')
      end
    end

  end

  context "instructor's scenario CRUD" do

    before do
      Scenario.stub(:find).and_return(mock_scenario(:user => current_user, :shared? => nil, :belongs_to_user? => true))
    end

    describe "GET index" do
      it "should expose scenarios" do
        current_user.stub_chain(:created_scenarios, :paginate).and_return([mock_scenario])
        get :index
        assigns[:scenarios].should eq([mock_scenario])
      end

      it "should render index" do
        current_user.stub_chain(:created_scenarios, :paginate).and_return([mock_scenario])
        get :index
        response.should render_template(:index)
      end
    end

    describe "GET show" do
      it "should exponse scenario" do
        get :show, :id => '37'
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should render show" do
        get :show, :id => '37'
        response.should render_template(:show)
      end

      it "should render show if the requested scenario is a shared scenario" do
        chuck     = Factory(:admin)
        scenario  = Factory(:valid_scenario, :user => chuck, :shared => true)
        get :show, :id => scenario.id
        response.code.should eq("200")
        response.should render_template(:show)
      end

      it "should redirect and render flash message when the requested scenario does not belong to the instructor" do
        chuck       = Factory(:admin)
        instructor  = Factory(:instructor)
        scenario    = Factory(:valid_scenario, :user => chuck)
        Scenario.stub_chain(:find, :belongs_to_user?).and_return(false)
        Scenario.stub_chain(:find, :shared?         ).and_return(false)
        controller.stub(:current_user).and_return(instructor)
        get :show, :id => scenario.id
        response.should redirect_to(instructors_scenarios_path)
        flash[:warning].should eq("Access forbidden for this scenario.")
      end

      it "should show the requested scenario even thought it does not belong to the instructor when it is shared one" do
        chuck       = Factory(:admin)
        instructor  = Factory(:instructor)
        scenario    = Factory(:valid_scenario, :user => chuck)
        controller.stub(:current_user).and_return(instructor)
        Scenario.stub_chain(:find, :belongs_to_user?).and_return(false)
        Scenario.stub_chain(:find, :shared?         ).and_return(true)
        get :show, :id => scenario.id
        response.code.should eq("200")
      end
    end

    describe "GET new" do
      it "should init and expose scenario" do
        Scenario.should_receive(:new).and_return(mock_scenario)
        get :new
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should render the new template" do
        Scenario.stub(:new).and_return(mock_scenario)
        get :new
        response.should render_template(:new)
      end
    end

    describe "GET edit" do
      it "should expose scenario" do
        get :edit, :id => "37"
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should render the edit template" do
        get :edit, :id => "37"
        response.should render_template(:edit)
      end
    end

    describe "PUT update" do

      describe "successfully" do
        before { mock_scenario.stub(:update_attributes).and_return(true) }

        it "should expose scenario" do
          put :update, :id => "37", :scenario => {}
          assigns[:scenario].should eq(mock_scenario)
        end

        it "should redirect" do
          put :update, :id => "37", :scenario => {}
          response.should redirect_to(instructors_scenario_path(assigns[:scenario]))
        end

      end

      describe "unssuccessfully" do
        before { mock_scenario.stub(:update_attributes).and_return(false) }

        it "should render edit template" do
          put :update, :id => "37", :scenario => {}
          response.should render_template(:edit)
        end

        it "should expose scenario" do
          put :update, :id => "37", :scenario => {}
          assigns[:scenario].should eq(mock_scenario)
        end
      end
    end

    describe "DELETE destroy" do

      it "should delete" do
        mock_scenario.should_receive(:destroy).and_return(true)
        delete :destroy, :id => "37"
      end

      it "should expose scenario" do
        delete :destroy, :id => "37"
        assigns[:scenario].should eq(mock_scenario)
      end

      it "should redirect" do
        delete :destroy, :id => "37"
        response.should redirect_to(instructors_scenarios_url)
      end

    end

  end
end
