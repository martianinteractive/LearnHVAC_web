class InstructorSystemVariablesController < ApplicationController
  before_filter :require_instructor
  layout "application"
  
  def index
    @instructor_system_variables = InstructorSystemVariable.all
  end

  def show
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])
  end

  def new
    @instructor_system_variable = InstructorSystemVariable.new
  end

  def edit
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])
  end

  def create
    @instructor_system_variable = InstructorSystemVariable.new(params[:instructor_system_variable])
    @instructor_system_variable.user = current_user
    
    if @instructor_system_variable.save
      redirect_to(@instructor_system_variable, :notice => 'InstructorSystemVariable was successfully created.')
    else
      render :action => :new
    end
  end

  def update
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])

    if @instructor_system_variable.update_attributes(params[:instructor_system_variable])
      redirect_to(@instructor_system_variable, :notice => 'InstructorSystemVariable was successfully updated.')
    else
      render :action => :edit
    end
  end

  def destroy
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])
    @instructor_system_variable.destroy

    redirect_to(instructor_system_variables_url)
  end

end
