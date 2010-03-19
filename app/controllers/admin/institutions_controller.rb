class Admin::InstitutionsController < ApplicationController
  before_filter :require_admin
  layout "admin"
  
  def index
    @institutions = Institution.all
  end

  def show
    @institution = Institution.find(params[:id])
  end

  def new
    @institution = Institution.new
  end

  def edit
    @institution = Institution.find(params[:id])
  end

  def create
    @institution = Institution.new(params[:institution])
    if @institution.save
      redirect_to(admin_institution_path(@institution), :notice => 'Institution was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @institution = Institution.find(params[:id])
    if @institution.update_attributes(params[:institution])
      redirect_to(admin_institution_path(@institution), :notice => 'Institution was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @institution = Institution.find(params[:id])
    @institution.destroy
    redirect_to(admin_institutions_url)
  end
  
end
