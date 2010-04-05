class InstitutionManagers::InstructorsController < InstitutionManagers::ApplicationController  
  
  def index
    @instructors = current_user.institution.users.instructor.paginate :page => params[:page], :per_page => 25
  end
end
