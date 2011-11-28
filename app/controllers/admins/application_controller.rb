class Admins::ApplicationController < ApplicationController

  layout 'bootstrap'

  before_filter :require_admin

  def load_variables_filters
    @filters = {}
    [:disabled, :is_fault, :fault_is_active].each do |filter|
      @filters[filter] = params[filter] if params[filter]
    end
  end

end
