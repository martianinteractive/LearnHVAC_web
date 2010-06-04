# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails.root)
require 'rspec/rails'
require 'ruby-debug'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  require 'rspec/expectations'
  config.include Rspec::Matchers
  config.mock_with :mocha
  config.before(:each) { Mongoid.master.collections.each(&:drop) }
end

module AuthlogicTestHelper 
 def login_as(user)
   @user_session = mock('user_session')
   @user_session.stubs(:user).returns(user)
   @user_session.stubs(:record).returns(user)
   @user_session.stubs(:destroy)
   UserSession.stubs(:find).returns(@user_session) 
 end 
 
 def user_logout
   @user_session = nil 
   UserSession.stubs(:find).returns(nil) 
 end
 
 def admin_login
   @admin = user_with_role(:admin)
   login_as(@admin)
 end
 
 #Peding, use this method to create user with roles
 #Improve to support atts.
 def user_with_role(role, _save=true, atts={})
  user = Factory.build(:user, {:login => role.to_s, :email => "#{role.to_s}@#{role.to_s}.com"}.merge(atts))
  user.role_code = User::ROLES[role]
  user.save if _save
  user
 end
 
 def default_path_for(user)
   case user.role
   when :admin
     admin_dashboard_path
   when :instructor
     instructor_dashboard_path
   when :institution_manager
     institution_managers_instructors_path
   when :student
     students_groups_path
   when :guest
     guests_dashboard_path
   else
     raise ArgumentError, "role is required"
   end
 end
 
end

module AuthorizationTestHelper  
  def authorize_actions(method_actions= default_actions)
    method_actions.each { |method, actions|
      actions.each { |action| 
        send(method, action)
        yield
      }
    }
  end
  
  def default_actions
    {:get => [:index, :show, :new, :edit],  :post => [ :create ], :put => [ :update ], :delete => [ :destroy ]}
  end
end

include AuthlogicTestHelper
include AuthorizationTestHelper