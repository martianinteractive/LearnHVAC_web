require File.dirname(__FILE__) + "/../../spec_helper"

describe Managers::GroupsController do
  let(:current_user) { Factory.stub(:manager) }
  
  before { controller.stub(:current_user).and_return(current_user) }
  
  def mock_group(stubs={})
    @mock_group ||= mock_model(Group, {:name => 'bla'}.merge(stubs))
  end
  
  context "GET index" do
    it "should expose groups" do
      current_user.stub_chain(:institution, :groups, :paginate).and_return([mock_group])
      get :index
      assigns[:groups].should eq([mock_group])
    end
    
    it "should render the index template" do
      current_user.stub_chain(:institution, :groups, :paginate).and_return([mock_group])
      get :index
      response.should render_template(:index)
    end
  end
  
  context "GET show" do
    before { current_user.stub_chain(:institution, :groups, :find).and_return(mock_group) }
    
    it "should expose group" do
       get :show, :id => "37"
       assigns[:group].should eq(mock_group)
    end
    
    it "should render the show template" do
      get :show, :id => "37"
      response.should render_template(:show)
    end
  end
  
  context "GET new" do
    it "should expose group" do
      Group.should_receive(:new).and_return(mock_group)
      get :new
      assigns[:group].should eq(mock_group)
    end
    
    it "should render the new template" do
      Group.stub(:new).and_return(mock_group)
      get :new
      response.should render_template(:new)
    end
  end
  
  context "POST: create" do
    context "successfully" do
      before { mock_group.stub(:save).and_return(true) }
      
      it "should expose group" do
        Group.should_receive(:new).with({"name" => "bla"}).and_return(mock_group)
        post :create, :group => {:name => "bla"}
        assigns[:group].should eq(mock_group)
      end
      
      it "should redirect" do
        Group.stub(:new).and_return(mock_group)
        post :create, :group => {}
        response.should redirect_to(managers_class_path(assigns[:group]))
      end
    end
    
    context "unsuccessfully" do
      before { mock_group.stub(:save).and_return(false) }
      
      it "should expose group" do
        Group.should_receive(:new).with({"name" => "bla"}).and_return(mock_group)
        post :create, :group => {:name => "bla"}
        assigns[:group].should eq(mock_group)
      end
      
      it "should render the new template" do
        Group.stub(:new).and_return(mock_group)
        post :create, :group => {}
        response.should render_template(:new)
      end
    end
  end
    
  context "PUT update" do
    before { current_user.stub_chain(:institution, :groups, :find).and_return(mock_group) }
    
    context "successfuly" do
      before { mock_group.stub(:update_attributes).and_return(true) }
    
      it "should expose group" do
        mock_group.should_receive(:update_attributes).and_return(true)
        put :update, :id => "37", :group => {}
        assigns[:group].should eq(mock_group)
      end
      
      it "should redirect" do
        mock_group.stub(:update_attributes).and_return(true)
        put :update, :id => "37", :group => {}
        response.should redirect_to(managers_class_path(assigns[:group]))
      end
    end
    
    context "unsuccessfully" do
      before { mock_group.stub(:update_attributes).and_return(false) }
      
      it "should expose group" do
        mock_group.should_receive(:update_attributes).and_return(false)
        put :update, :id => "37", :group => {}
        assigns[:group].should eq(mock_group)
      end
      
      it "should render the edit template" do
        mock_group.stub(:update_attributes).and_return(false)
        put :update, :id => "37", :group => {}
        response.should render_template(:edit)
      end
    end
  end
  
  context "DELETE destroy" do
    before { current_user.stub_chain(:institution, :groups, :find).and_return(mock_group) }
    
    it "should expose group" do
      delete :destroy, :id => "37"
      assigns[:group].should eq(mock_group)
    end
    
    it "should redirect" do
      delete :destroy, :id => "37"
      response.should redirect_to(managers_class_path)
    end
  end

  # render_views
  # 
  # before(:each) do
  #   institution   = Factory(:institution)
  #   @manager      = Factory(:manager, :institution => institution)
  #   @instructor   = Factory(:instructor, :institution => institution)
  #   @scenario     = Factory(:scenario, :user => @instructor, :master_scenario => Factory(:master_scenario, :user => Factory(:admin)))
  #   @group        = Factory(:group, :name => "Class 01", :creator => @instructor, :scenario_ids => [@scenario.id])
  #   login_as(@manager)
  # end
  # 
  # describe "GET index" do
  #   it "" do
  #     get :index
  #     response.should render_template(:index)
  #     assigns(:groups).should_not be_empty
  #     assigns(:groups).should eq([@group])
  #   end
  # end
  # 
  # describe "GET show" do
  #   it "" do
  #     get :show, :id => @group.id
  #     response.should render_template(:show)
  #     assigns(:group).should eq(@group)
  #   end
  # end
  # 
  # describe "GET new" do
  #   it "" do
  #     get :new
  #     response.should render_template(:new)
  #     assigns(:group).should be_instance_of(Group)
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "" do
  #     get :edit, :id => @group.id
  #     response.should render_template(:edit)
  #     assigns(:group).should eq(@group)
  #   end
  # end
  # 
  # describe "POST create" do
  #   describe "with valid params" do
  #     
  #     it "should change the Group count" do
  #       proc{ post :create, 
  #             :group => {:name => "monkeygroup", :code => "0973872", :creator => @instructor, :scenario_ids => [@scenario.id] } 
  #           }.should change(Group, :count).by(1)
  #     end
  #     
  #     it "redirects to the created group" do
  #       post :create, :group => {:name => "monkeygroup", :code => "0973872", :creator => @instructor, :scenario_ids => [@scenario.id] } 
  #       response.should redirect_to(managers_class_path(assigns(:group)))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "should render new template" do
  #       post :create, :group => {:name => "", :code => "0973872"}
  #       response.should render_template(:new)
  #     end
  #   end
  # end
  # 
  # describe "PUT update" do    
  #   describe "with valid params" do      
  #     it "updates the requested group" do
  #       put :update, :id => @group.id, :group => { :name => "CS Group" }
  #       @group.reload.name.should == "CS Group"
  #     end
  #     
  #     it "" do
  #       put :update, :id => @group.id, :group => { }
  #       response.should redirect_to(managers_class_path(@group))
  #     end
  #   end
  #   
  #   describe "with invalid params" do  
  #     it "" do
  #       put :update, :id => @group.id, :group => { :name => "" }
  #       response.should render_template(:edit)
  #     end
  #   end
  # end
  # 
  # describe "DELETE destroy" do    
  #   it "destroys the requested group" do
  #     proc { delete :destroy, :id => @group.id }.should change(Group, :count).by(-1)
  #   end
  # 
  #   it "redirects to the instructor groups list" do
  #     delete :destroy, :id => @group.id
  #     response.should redirect_to(managers_class_path)
  #   end
  # end
  
end

