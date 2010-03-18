class SystemVariablesController < ApplicationController
  before_filter :require_instructor
  
  def index
    @system_variables = SystemVariable.all
  end

  def show
    @system_variable = SystemVariable.find(params[:id])
  end

  def new
    @system_variable = SystemVariable.new
  end

  def edit
    @system_variable = SystemVariable.find(params[:id])
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
    @system_variable = SystemVariable.find(params[:id])

    if @system_variable.update_attributes(params[:system_variable])
      redirect_to(@system_variable, :notice => 'SystemVariable was successfully updated.')
    else
      render :action => :edit
    end
  end

  def destroy
    @system_variable = SystemVariable.find(params[:id])
    @system_variable.destroy

    redirect_to(system_variables_url)
  end

end
