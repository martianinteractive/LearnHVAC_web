class Directory::ApplicationController < ApplicationController
  before_filter :require_user
  before_filter :set_layout
  add_crumb("Directory") { |instance| instance.send :directory_path }
  
  private
  
  def set_layout
    @fconnect_site_id = Site.config["fconnect_site_id"]
    @show_connection = true
    self.class.layout current_user_layout
  end
  
end
