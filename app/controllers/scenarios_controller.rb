class ScenariosController < ApplicationController
  before_filter :require_user
  before_filter :set_layout
  
  def show
    @institution = Institution.find(params[:institution_id])
    @scenario = @institution.scenarios.public.criteria.id(params[:id]).first
  end
  
  private
  
  def set_layout
    self.class.layout current_user_layout
  end
end
