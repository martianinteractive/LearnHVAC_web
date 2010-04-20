class InstitutionsController < ApplicationController
  before_filter :require_user
  before_filter :set_layout  
  
  def show
    @institution = Institution.find(params[:id])
    @public_scenarios = @institution.scenarios.public.to_a.paginate :page => params[:page], :per_page => 25
  end
  
  private
  
  def set_layout
    self.class.layout current_user_layout
  end
  
end
