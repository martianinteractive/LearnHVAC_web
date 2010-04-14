require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::SettingsController do
  
  describe "GET :index" do
    it "" do
      admin_login
      get :index
      response.should render_template(:index)
    end
  end

end
