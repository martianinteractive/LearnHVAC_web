require File.dirname(__FILE__) + "/../spec_helper"

describe MembershipsController do
  
  before(:each) do
    @instructor   = user_with_role(:instructor)
    @group        = Factory.build(:group, :name => "Class 01", :instructor => @instructor)
    @group.expects(:scenario_validator).returns(true) #skip scenarios assignment.
    @group.save
    @student      = user_with_role(:student)
    login_as(@student)
  end
  
  describe "POST :create" do
    describe "with valid params" do
      it "" do
        proc { post :create, :code => @group.code }.should change(Membership, :count).by(1)
      end
      
      it "" do
        post :create, :code => @group.code
        response.should redirect_to(students_group_path(@group))
      end
    end
    
    describe "with invalid params" do
      describe "Trying to register an existing membership" do
        before(:each) do
          Membership.create(:group => @group, :student => @student)
        end
        
        it { proc { post :create, :code => @group.code }.should_not change(Membership, :count) }
        
        it "" do
          post :create, :code => @group.code
          response.should redirect_to(students_group_path(@group))
        end
      end
      
      describe "As a logged instructor" do
        describe "and the instructor is the group instructor" do
          before { login_as(@instructor) }
        
          it { proc { post :create, :code => @group.code }.should_not change(Membership, :count) }
        
          it "" do
            post :create, :code => @group.code
            flash[:notice].should == "You already have joined this group as instructor."
            response.should redirect_to(group_path(@group))
          end
        end
        
        describe "and the instructor isn't the group instructor." do
          before(:each) do
            @instructor2 = user_with_role(:instructor, 1, { :login => "instructor2", :email => "inst2@inst.com"})
            login_as(@instructor2)
          end
          
          it "" do
            post :create, :code => @group.code
            flash[:notice].should == "You need to login as student to join groups."
            response.should redirect_to(default_path_for(@instructor2))
          end
        end
      end
      
      pending "fix the 404 response."
      # describe "Trying to register a non-existent group" do
      #   it "" do
      #     post :create, :code => "fakecode"
      #     response.should render_template("#{Rails.root}/public/404.html")
      #   end
      # end
    end
    
    
    describe "DELETE :destroy" do
      before(:each) do 
        @membership = Membership.create(:group => @group, :student => @student)
        login_as(@instructor)
      end
      
      it "" do
        proc { delete :destroy, :group_id => @group.id, :id => @membership.id }.should change(Membership, :count).by(-1)
      end
      
      it "" do
        delete :destroy, :group_id => @group.id, :id => @membership.id
        response.should redirect_to(group_path(@group))
      end
    end
    
    describe "without authentication" do
      before(:each) do
        user_logout
      end
      
      it "" do
        post :create
        response.should redirect_to(students_signup_path)
      end
    end
  end
  
end
