class ScenarioSystemVariablesController < ApplicationController
  # GET /scenario_system_variables
  # GET /scenario_system_variables.xml
  def index
    @scenario_system_variables = ScenarioSystemVariable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenario_system_variables }
    end
  end

  # GET /scenario_system_variables/1
  # GET /scenario_system_variables/1.xml
  def show
    @scenario_system_variable = ScenarioSystemVariable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scenario_system_variable }
    end
  end

  # GET /scenario_system_variables/new
  # GET /scenario_system_variables/new.xml
  def new
    @scenario_system_variable = ScenarioSystemVariable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scenario_system_variable }
    end
  end

  # GET /scenario_system_variables/1/edit
  def edit
    @scenario_system_variable = ScenarioSystemVariable.find(params[:id])
  end

  # POST /scenario_system_variables
  # POST /scenario_system_variables.xml
  def create
    @scenario_system_variable = ScenarioSystemVariable.new(params[:scenario_system_variable])

    respond_to do |format|
      if @scenario_system_variable.save
        format.html { redirect_to(@scenario_system_variable, :notice => 'ScenarioSystemVariable was successfully created.') }
        format.xml  { render :xml => @scenario_system_variable, :status => :created, :location => @scenario_system_variable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scenario_system_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scenario_system_variables/1
  # PUT /scenario_system_variables/1.xml
  def update
    @scenario_system_variable = ScenarioSystemVariable.find(params[:id])

    respond_to do |format|
      if @scenario_system_variable.update_attributes(params[:scenario_system_variable])
        format.html { redirect_to(@scenario_system_variable, :notice => 'ScenarioSystemVariable was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scenario_system_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scenario_system_variables/1
  # DELETE /scenario_system_variables/1.xml
  def destroy
    @scenario_system_variable = ScenarioSystemVariable.find(params[:id])
    @scenario_system_variable.destroy

    respond_to do |format|
      format.html { redirect_to(scenario_system_variables_url) }
      format.xml  { head :ok }
    end
  end
end
