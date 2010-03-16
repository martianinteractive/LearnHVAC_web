class InstructorSystemVariablesController < ApplicationController
  # GET /instructor_system_variables
  # GET /instructor_system_variables.xml
  def index
    @instructor_system_variables = InstructorSystemVariable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instructor_system_variables }
    end
  end

  # GET /instructor_system_variables/1
  # GET /instructor_system_variables/1.xml
  def show
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @instructor_system_variable }
    end
  end

  # GET /instructor_system_variables/new
  # GET /instructor_system_variables/new.xml
  def new
    @instructor_system_variable = InstructorSystemVariable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @instructor_system_variable }
    end
  end

  # GET /instructor_system_variables/1/edit
  def edit
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])
  end

  # POST /instructor_system_variables
  # POST /instructor_system_variables.xml
  def create
    @instructor_system_variable = InstructorSystemVariable.new(params[:instructor_system_variable])

    respond_to do |format|
      if @instructor_system_variable.save
        format.html { redirect_to(@instructor_system_variable, :notice => 'InstructorSystemVariable was successfully created.') }
        format.xml  { render :xml => @instructor_system_variable, :status => :created, :location => @instructor_system_variable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @instructor_system_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /instructor_system_variables/1
  # PUT /instructor_system_variables/1.xml
  def update
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])

    respond_to do |format|
      if @instructor_system_variable.update_attributes(params[:instructor_system_variable])
        format.html { redirect_to(@instructor_system_variable, :notice => 'InstructorSystemVariable was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @instructor_system_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /instructor_system_variables/1
  # DELETE /instructor_system_variables/1.xml
  def destroy
    @instructor_system_variable = InstructorSystemVariable.find(params[:id])
    @instructor_system_variable.destroy

    respond_to do |format|
      format.html { redirect_to(instructor_system_variables_url) }
      format.xml  { head :ok }
    end
  end
end
