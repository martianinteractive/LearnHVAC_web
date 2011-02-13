class Admins::SettingsController < Admins::ApplicationController
  
  def index
    add_crumb "Settings", "settings"
  end
  
end
