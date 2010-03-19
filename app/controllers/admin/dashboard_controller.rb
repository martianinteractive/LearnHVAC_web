class Admin::DashboardController < ApplicationController  
  before_filter :require_admin
  layout 'admin'
  
  def show    
  end
  
end
