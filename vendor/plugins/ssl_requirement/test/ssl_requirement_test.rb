require 'set'
require 'rubygems'
require 'active_support'
begin
  require 'action_controller'
rescue LoadError
  if ENV['ACTIONCONTROLLER_PATH'].nil?
    abort <<MSG
Please set the ACTIONCONTROLLER_PATH environment variable to the directory
containing the action_controller.rb file.
MSG
  else
    $LOAD_PATH.unshift ENV['ACTIONCONTROLLER_PATH']
    begin
      require 'action_controller'
    rescue LoadError
      abort "ActionController could not be found."
    end
  end
end

require 'action_controller/test_process'
require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/ssl_requirement"

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

# several test controllers to cover different combinations of requiring/
# allowing/exceptions-ing SSL for controller actions

# this first controller modifies the flash in every action so that flash
# set in set_flash is eventually expired (see NOTE below...)

class SslRequirementController < ActionController::Base
  include SslRequirement
  
  ssl_required :a, :b
  ssl_allowed :c
  
  def a
    flash[:abar] = "foo"
    render :nothing => true
  end
  
  def b
    flash[:bbar] = "foo"
    render :nothing => true
  end
  
  def c
    flash[:cbar] = "foo"
    render :nothing => true
  end
  
  def d
    flash[:dbar] = "foo"
    render :nothing => true
  end

  def set_flash
    flash[:foo] = "bar"
  end
end

class SslExceptionController < ActionController::Base
  include SslRequirement
  
  ssl_required  :a
  ssl_exceptions :b
  ssl_allowed :d
    
  def a
    render :nothing => true
  end
  
  def b
    render :nothing => true
  end
  
  def c
    render :nothing => true
  end
  
  def d
    render :nothing => true
  end
  
end

class SslAllActionsController < ActionController::Base
  include SslRequirement
  
  ssl_exceptions
    
  def a
    render :nothing => true
  end
  
end

# NOTE: The only way I could get the flash tests to work under Rails 2.3.2
#       (without resorting to IntegrationTest with some artificial session
#       store) was to use TestCase. In TestCases, it appears that flash 
#       messages are effectively persisted in session after the last controller
#       action that consumed them...so that when the TestCase inspects
#       the FlashHash, it will find the flash still populated, even though
#       the subsequent controller action won't see it.
#
#       In addition, if no changes are made to flash in subsequent requests, the
#       flash is persisted forever. But if subsequent controller actions add to
#       flash, the older flash messages eventually disappear.
#
#       As a result, the flash-related tests now make two requests after the 
#       set_flash, each of these requests is also modifying flash. flash is 
#       inspected after the second request returns.
#
#       This feels a little hacky, so if anyone can improve it, please do so!

class SslRequirementTest < ActionController::TestCase
  def setup
    @controller = SslRequirementController.new
    @ssl_host_override = 'www.example.com:80443'
    @non_ssl_host_override = 'www.example.com:8080'
  end

  # port preservation tests

  def test_redirect_to_https_preserves_non_normal_port
    assert_not_equal "on", @request.env["HTTPS"]
    @request.port = 4567
    get :b
    assert_response :redirect
    assert_match %r{^https://.*:4567/}, @response.headers['Location']
  end

  def test_redirect_to_https_does_not_preserve_normal_port
    assert_not_equal "on", @request.env["HTTPS"]
    get :b
    assert_response :redirect
    assert_match %r{^https://.*[^:]/}, @response.headers['Location']
  end

  # flash-related tests
  
  def test_redirect_to_https_preserves_flash
    assert_not_equal "on", @request.env["HTTPS"]
    get :set_flash
    get :b
    assert_response :redirect       # check redirect happens (flash still set)
    get :b                          # get again to flush flash
    assert_response :redirect       # make sure it happens again
    assert_equal "bar", flash[:foo] # the flash would be gone now if no redirect
  end
  
  def test_not_redirecting_to_https_does_not_preserve_the_flash
    assert_not_equal "on", @request.env["HTTPS"]
    get :set_flash
    get :d
    assert_response :success        # check no redirect (flash still set)
    get :d                          # get again to flush flash
    assert_response :success        # check no redirect
    assert_nil flash[:foo]          # the flash should be gone now
  end
  
  def test_redirect_to_http_preserves_flash
    get :set_flash
    @request.env['HTTPS'] = "on"
    get :d
    assert_response :redirect       # check redirect happens (flash still set)
    get :d                          # get again to flush flash
    assert_response :redirect       # make sure redirect happens
    assert_equal "bar", flash[:foo] # flash would be gone now if no redirect
  end
  
  def test_not_redirecting_to_http_does_not_preserve_the_flash
    get :set_flash
    @request.env['HTTPS'] = "on"
    get :a
    assert_response :success        # no redirect (flash still set)
    get :a                          # get again to flush flash
    assert_response :success        # no redirect
    assert_nil flash[:foo]          # flash should be gone now
  end

  # ssl required/allowed/exceptions testing
  
  def test_required_without_ssl
    assert_not_equal "on", @request.env["HTTPS"]
    get :a
    assert_response :redirect
    assert_match %r{^https://}, @response.headers['Location']
    get :b
    assert_response :redirect
    assert_match %r{^https://}, @response.headers['Location']
  end
  
  def test_required_with_ssl
    @request.env['HTTPS'] = "on"
    get :a
    assert_response :success
    get :b
    assert_response :success
  end

  def test_disallowed_without_ssl
    assert_not_equal "on", @request.env["HTTPS"]
    get :d
    assert_response :success
  end
  
  def test_ssl_exceptions_without_ssl
    @controller = SslExceptionController.new
    assert_not_equal "on", @request.env["HTTPS"]
    get :a
    assert_response :redirect
    assert_match %r{^https://}, @response.headers['Location']
    get :b
    assert_response :success
    get :c # c is not explicity in ssl_required, but it is not listed in ssl_exceptions
    assert_response :redirect
    assert_match %r{^https://}, @response.headers['Location']
  end
    
  def test_ssl_exceptions_with_ssl
    @controller = SslExceptionController.new
    @request.env['HTTPS'] = "on"
    get :a
    assert_response :success
    get :c
    assert_response :success
  end
  
  def test_ssl_all_actions_without_ssl
    @controller = SslAllActionsController.new
    get :a
    assert_response :redirect
    assert_match %r{^https://}, @response.headers['Location']
  end
  
  def test_disallowed_with_ssl
    @request.env['HTTPS'] = "on"
    get :d
    assert_response :redirect
    assert_match %r{^http://}, @response.headers['Location']
  end

  def test_allowed_without_ssl
    assert_not_equal "on", @request.env["HTTPS"]
    get :c
    assert_response :success
  end

  def test_allowed_with_ssl
    @request.env['HTTPS'] = "on"
    get :c
    assert_response :success
  end

  def test_disable_ssl_check
    SslRequirement.disable_ssl_check = true

    assert_not_equal "on", @request.env["HTTPS"]
    get :a
    assert_response :success
    get :b
    assert_response :success
  ensure
    SslRequirement.disable_ssl_check = false
  end

  # testing overriding hostnames for ssl, non-ssl

  # test for overriding (or not) the ssl_host and non_ssl_host variables
  # using actions a (ssl required) and d (ssl not required or allowed)

  def test_ssl_redirect_with_ssl_host
    SslRequirement.ssl_host = @ssl_host_override
    assert_not_equal "on", @request.env["HTTPS"]
    get :a
    assert_response :redirect
    assert_match Regexp.new("^https://#{@ssl_host_override}"),
                 @response.headers['Location']
    SslRequirement.ssl_host = nil
  end

  def test_ssl_redirect_without_ssl_host
    SslRequirement.ssl_host = nil
    assert_not_equal "on", @request.env["HTTPS"]
    get :a
    assert_response :redirect
    assert_match Regexp.new("^https://"), @response.headers['Location']
    assert_no_match Regexp.new("^https://#{@ssl_host_override}"),
                    @response.headers['Location']
  end

  def test_non_ssl_redirect_with_non_ssl_host
    SslRequirement.non_ssl_host = @non_ssl_host_override
    @request.env['HTTPS'] = 'on'
    get :d
    assert_response :redirect
    assert_match Regexp.new("^http://#{@non_ssl_host_override}"),
                 @response.headers['Location']
    SslRequirement.non_ssl_host = nil
  end

  def test_non_ssl_redirect_without_non_ssl_host
    SslRequirement.non_ssl_host = nil
    @request.env['HTTPS'] = 'on'
    get :d
    assert_response :redirect
    assert_match Regexp.new("^http://"), @response.headers['Location']
    assert_no_match Regexp.new("^http://#{@non_ssl_host_override}"),
                    @response.headers['Location']
  end

  # test ssl_host and ssl_non_host overrides with Procs
  
  def test_ssl_redirect_with_ssl_host_proc
    SslRequirement.ssl_host = Proc.new do
      @ssl_host_override
    end
    assert_not_equal "on", @request.env["HTTPS"]
    get :a
    assert_response :redirect
    assert_match Regexp.new("^https://#{@ssl_host_override}"), 
                 @response.headers['Location']
    SslRequirement.ssl_host = nil
  end

  def test_non_ssl_redirect_with_non_ssl_host_proc
    SslRequirement.non_ssl_host = Proc.new do
      @non_ssl_host_override 
    end
    @request.env['HTTPS'] = 'on'
    get :d
    assert_response :redirect
    assert_match Regexp.new("^http://#{@non_ssl_host_override}"),
                 @response.headers['Location']
    SslRequirement.non_ssl_host = nil
  end
end
