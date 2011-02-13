class Admins::ApplicationController < ApplicationController
  before_filter :require_admin
  layout "admins"
  
  add_crumb "Dashboard", '/admins/dashboard'
  
end
