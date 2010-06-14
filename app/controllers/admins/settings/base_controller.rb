class Admins::Settings::BaseController < Admins::ApplicationController
    add_crumb("Settings") { |instance| instance.send :admins_settings_path }
    
end