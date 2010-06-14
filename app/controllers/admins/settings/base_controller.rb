class Admins::Settings::BaseController < Admins::ApplicationController
    add_crumb("Settings") { |instance| instance.send :admin_settings_path }
    
end