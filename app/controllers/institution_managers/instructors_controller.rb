class InstitutionManagers::InstructorsController < InstitutionManagers::ApplicationController  
  before_filter :find_instructor, :only => [:show, :edit, :update, :destroy]
  
  def index
    @instructors = current_user.institution.users.instructor.paginate :page => params[:page], :per_page => 25
  end
  
  def show
  end
  
  def new
    @instructor = User.new
  end
  
  def edit
  end
  
  def create
    @instructor = User.new(params[:user])
    @instructor.institution = current_user.institution
    @instructor.role_code = User::ROLES[:instructor]
    
    if @instructor.save
      redirect_to(institution_managers_instructor_path(@instructor), :notice => 'Instructor was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def update
    @instructor.institution = current_user.institution
    @instructor.role_code = User::ROLES[:instructor]
    
    if @instructor.update_attributes(params[:user])
      redirect_to(institution_managers_instructor_path(@instructor), :notice => 'Instructor was successfully created.')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @instructor.destroy
    redirect_to(institution_managers_instructors_path)
  end
  
  private
  
  def find_instructor
    @instructor = current_user.institution.users.instructor.find(params[:id])
  end

end
