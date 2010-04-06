class InstitutionManagers::ApplicationController < ApplicationController
  before_filter :require_institution_manager
  layout "institution_managers"
end