require 'test_helper'

class ScenariosControllerTest < ActionController::TestCase
  
  def setup
    super
    login_as :daniel
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:scenario)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_scenario
    assert_difference('Scenario.count') do
      post :create, :scenario => { :scenID => "testScenario1"}
    end
    assert_redirected_to scenario_path(assigns(:scenario))
  end

  def test_should_show_scenario
    get :show, :id => scenario(:spring).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => scenario(:spring).id
    assert_response :success
  end

  def test_should_update_scenario
    put :update, :id => scenario(:spring).id, :scenario => { }
    assert_redirected_to scenario_path(assigns(:scenario))
  end

  def test_should_destroy_scenario
    assert_difference('Scenario.count', -1) do
      delete :destroy, :id => scenario(:spring).id
    end

    assert_redirected_to scenario_path
  end
  
  def test_xml_should_have_
  
  protected
  
    def login_as (person)
      @request.session[:loggedInUserID] = users(person).id
    end

end
