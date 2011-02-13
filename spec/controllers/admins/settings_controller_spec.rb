require File.dirname(__FILE__) + "/../../spec_helper"

describe Admins::SettingsController do
  
  describe "GET :index" do
    it "" do
      admins_login
      get :index
      response.should render_template(:index)
    end
  end

end
