class Directory::ScenariosController < Directory::ApplicationController
  
  def show
    @institution = Institution.find(params[:institution_id])
    @scenario = @institution.scenarios.public.criteria.id(params[:id]).first
  end
  
end
