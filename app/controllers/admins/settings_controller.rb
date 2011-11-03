class Admins::SettingsController < Admins::ApplicationController

  layout 'bootstrap'

  def index
    add_crumb "Settings", "settings"
  end

end
