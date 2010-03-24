class SystemVariablesController < ApplicationController
  before_filter :require_instructor
  before_filter :find_system_variable, :only => [:show, :edit, :update, :destroy]
  
  def index
    @system_variables = current_user.system_variables.paginate :page => params[:page], :per_page => 25
  end

  def show
  end

  def new
    @system_variable = SystemVariable.new
  end

  def edit
  end

  def create
    @system_variable = SystemVariable.new(params[:system_variable])
    @system_variable.user = current_user
    
    if @system_variable.save
      redirect_to(@system_variable, :notice => 'SystemVariable was successfully created.')
    else
      render :action => :new
    end
  end

  def update
    if @system_variable.update_attributes(params[:system_variable])
      redirect_to(@system_variable, :notice => 'SystemVariable was successfully updated.')
    else
      render :action => :edit
    end
  end

  def destroy
    @system_variable.destroy
    redirect_to(system_variables_url)
  end
  
  private
  
  def find_system_variable
    @system_variable = current_user.find_system_variable(params[:id])
  end

end
