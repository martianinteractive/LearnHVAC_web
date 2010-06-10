class Directory::ApplicationController < ApplicationController
  before_filter :require_user
  before_filter :set_layout
  
  private
  
  def set_layout
    @show_connection = true
    self.class.layout current_user_layout
  end
  
end
