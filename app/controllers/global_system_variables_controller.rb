class GlobalSystemVariablesController < ApplicationController
  before_filter :require_admin
  layout "application"
  
  def index
    @global_system_variables = GlobalSystemVariable.all
  end

  def show
    @global_system_variable = GlobalSystemVariable.find(params[:id])
  end

  def new
    @global_system_variable = GlobalSystemVariable.new
  end

  def edit
    @global_system_variable = GlobalSystemVariable.find(params[:id])
  end

  def create
    @global_system_variable = GlobalSystemVariable.new(params[:global_system_variable])

    if @global_system_variable.save
      redirect_to(@global_system_variable, :notice => 'GlobalSystemVariable was successfully created.')
    else
      render :action => :new
    end
  end

  def update
    @global_system_variable = GlobalSystemVariable.find(params[:id])

    if @global_system_variable.update_attributes(params[:global_system_variable])
      redirect_to(@global_system_variable, :notice => 'GlobalSystemVariable was successfully updated.')
    else
      render :action => :edit
    end
  end

  def destroy
    @global_system_variable = GlobalSystemVariable.find(params[:id])
    @global_system_variable.destroy

    redirect_to(global_system_variables_url)
  end
end
