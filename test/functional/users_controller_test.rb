require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    super
    login_as :daniel
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:user)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user
    assert_difference('User.count') do
      u = create_user()
    end
    assert_redirected_to scenario_path(assigns(:user))
  end

  def test_should_show_user
    get :show, :id => users(:daniel).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => users(:daniel).id
    assert_response :success
  end

  def test_should_update_user
    put :update, :id => users(:daniel).id, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_destroy_user
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:daniel).id
    end
    assert_redirected_to scenario_path
  end
  
  protected
  
    def login_as (person)
      @request.session[:loggedInUserID] = users(person).id
    end


end
