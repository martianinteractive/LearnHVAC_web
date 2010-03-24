class Admin::InstructorVariablesController < ApplicationController
  before_filter :require_admin
  before_filter :find_instructor
  before_filter :find_instructor_variable, :only => [:show, :edit, :update, :destroy]
  layout "admin"
  
  def index
    @instructor_variables = @instructor.system_variables.paginate :page => params[:page], :per_page => 25
  end

  def show
  end

  def new
    @instructor_variable = SystemVariable.new
  end

  def edit
  end

  def create
    @instructor_variable = SystemVariable.new(params[:system_variable])
    @instructor_variable.user = @instructor
    
    if @instructor_variable.save
      redirect_to(admin_user_instructor_variable_path(@instructor, @instructor_variable), :notice => 'Instructor Variable was successfully created.')
    else
      render :action => :new
    end
  end

  def update
    if @instructor_variable.update_attributes(params[:system_variable])
      redirect_to(admin_user_instructor_variable_path(@instructor, @instructor_variable), :notice => 'Instructor Variable was successfully created.')
    else
      render :action => :edit
    end
  end

  def destroy
    @instructor_variable.destroy
    redirect_to(admin_user_instructor_variables_url(@instructor))
  end
  
  private
  
  def find_instructor
    @instructor = User.find(params[:user_id])
  end
  
  def find_instructor_variable
    @instructor_variable = @instructor.find_system_variable(params[:id])
  end
end
