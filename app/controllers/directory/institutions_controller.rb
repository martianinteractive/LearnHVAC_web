class Directory::InstitutionsController < Directory::ApplicationController
  add_crumb("Institutions") { |instance| instance.send :directory_institutions_path }
  
  def index
    @institutions = Institution.paginate :page => params[:page], :per_page => 25, :order => "created_at DESC"
  end
  
  def show
    @institution = Institution.find(params[:id])
    @public_scenarios = @institution.scenarios.public.paginate :page => params[:page], :per_page => 25
    add_crumb @institution.name, admins_institution_path(@institution)
  end
  
end
