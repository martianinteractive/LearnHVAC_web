class Admins::InstitutionsController < Admins::ApplicationController

  layout 'bootstrap'

  add_crumb("Institutions") { |instance| instance.send :admins_institutions_path }

  cache_sweeper :institution_sweeper, :only => [:create, :update, :destroy]

  def index
    @institutions = Institution.all
  end

  def show
    @institution = Institution.find(params[:id])
    @users = @institution.users.paginate :page => params[:page], :per_page => 25
    add_crumb @institution.name, admins_institution_path(@institution)
  end

  def new
    @institution = Institution.new
    add_crumb "New Institution", new_admins_institution_path
  end

  def edit
    @institution = Institution.find(params[:id])
    add_crumb "Editing #{@institution.name}", edit_admins_institution_path(@institution)
  end

  def create
    @institution = Institution.new(params[:institution])
    if @institution.save
      redirect_to(admins_institution_path(@institution), :notice => 'Institution was successfully created.')
    else
      add_crumb "New Institution", new_admins_institution_path
      render :action => "new"
    end
  end

  def update
    @institution = Institution.find(params[:id])
    if @institution.update_attributes(params[:institution])
      redirect_to(admins_institution_path(@institution), :notice => 'Institution was successfully updated.')
    else
      add_crumb "Editing #{@institution.name}", edit_admins_institution_path(@institution)
      render :action => "edit"
    end
  end

  def destroy
    @institution = Institution.find(params[:id])
    @institution.destroy
    redirect_to(admins_institutions_url)
  end

end
