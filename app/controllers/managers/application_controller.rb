class Managers::ApplicationController < ApplicationController
  before_filter :require_manager
  layout "managers"
  add_crumb "Dashboard", "/managers/dashboard"
end