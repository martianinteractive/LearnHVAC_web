class Managers::ApplicationController < ApplicationController
  before_filter :require_manager
  layout "managers"
end
