class Admins::ApplicationController < ApplicationController

  layout 'bootstrap'

  before_filter :require_admin

end
