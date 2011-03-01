require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::SettingsController do
  
  describe "GET :index" do
    it "" do
      login_as(:admin)
      get :index
      response.should render_template(:index)
    end
  end

end
