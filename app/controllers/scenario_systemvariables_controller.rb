class ScenarioSystemvariablesController < ApplicationController
  # GET /scenario_systemvariables
  # GET /scenario_systemvariables.xml


  # GET /scenario_systemvariables/1/edit
  def edit
    @scenario_systemvariables = ScenarioSystemvariable.find(:all, :conditions=>{:scenario_id =>params[:id]})
  end

  # PUT /scenario_systemvariables/1
  # PUT /scenario_systemvariables/1.xml
  def update
    @scenario_systemvariable = ScenarioSystemvariable.find(params[:id])

    respond_to do |format|
      if @scenario_systemvariable.update_attributes(params[:scenario_systemvariable])
        flash[:notice] = 'ScenarioSystemvariable was successfully updated.'
        format.html { redirect_to(@scenario_systemvariable) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scenario_systemvariable.errors, :status => :unprocessable_entity }
      end
    end
  end

end
