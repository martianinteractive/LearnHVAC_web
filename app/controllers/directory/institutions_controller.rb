class Directory::InstitutionsController < Directory::ApplicationController
  
  def index
    @institutions = Institution.with_public_scenarios.paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @institution = Institution.find(params[:id])
    # Avoid to_a when using a newest version of mongoid. Instead use the new paginate.
    @public_scenarios = @institution.scenarios.public.to_a.paginate :page => params[:page], :per_page => 25
  end
  
end
