ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
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
 
 def admins_login
   @admin = Factory(:admin)
   login_as(@admin)
 end
 
 def students_login
   @student = Factory(:student)
   login_as(@student)
 end
 
end

module AuthorizationTestHelper
  def authorize_actions(params={}, method_actions= default_actions)
    method_actions.each { |method, actions|
      actions.each { |action|
        send(method, action, params)
        yield
      }
    }
  end
  
  def default_actions
    {:get => [:index, :show, :new, :edit], :post => [ :create ], :put => [ :update ], :delete => [ :destroy ]}
  end
end

include AuthlogicTestHelper
include AuthorizationTestHelper