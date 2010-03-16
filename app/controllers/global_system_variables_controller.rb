class GlobalSystemVariablesController < ApplicationController
  # GET /global_system_variables
  # GET /global_system_variables.xml
  def index
    @global_system_variables = GlobalSystemVariable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @global_system_variables }
    end
  end

  # GET /global_system_variables/1
  # GET /global_system_variables/1.xml
  def show
    @global_system_variable = GlobalSystemVariable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @global_system_variable }
    end
  end

  # GET /global_system_variables/new
  # GET /global_system_variables/new.xml
  def new
    @global_system_variable = GlobalSystemVariable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @global_system_variable }
    end
  end

  # GET /global_system_variables/1/edit
  def edit
    @global_system_variable = GlobalSystemVariable.find(params[:id])
  end

  # POST /global_system_variables
  # POST /global_system_variables.xml
  def create
    @global_system_variable = GlobalSystemVariable.new(params[:global_system_variable])

    respond_to do |format|
      if @global_system_variable.save
        format.html { redirect_to(@global_system_variable, :notice => 'GlobalSystemVariable was successfully created.') }
        format.xml  { render :xml => @global_system_variable, :status => :created, :location => @global_system_variable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @global_system_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /global_system_variables/1
  # PUT /global_system_variables/1.xml
  def update
    @global_system_variable = GlobalSystemVariable.find(params[:id])

    respond_to do |format|
      if @global_system_variable.update_attributes(params[:global_system_variable])
        format.html { redirect_to(@global_system_variable, :notice => 'GlobalSystemVariable was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @global_system_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /global_system_variables/1
  # DELETE /global_system_variables/1.xml
  def destroy
    @global_system_variable = GlobalSystemVariable.find(params[:id])
    @global_system_variable.destroy

    respond_to do |format|
      format.html { redirect_to(global_system_variables_url) }
      format.xml  { head :ok }
    end
  end
end
