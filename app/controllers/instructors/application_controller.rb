class Instructors::ApplicationController < ApplicationController
  before_filter :require_instructor
  layout "instructors"
  
  add_crumb "Dashboard", '/instructors/dashboard'
end