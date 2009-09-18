class ScenariosController < ApplicationController

  before_filter :login_required

  def index
    
    if (current_user.institution=="administration")
      @scenarios = Scenario.find(:all, :order=> :institution)
    else
      @scenarios = Scenario.find(:all, :order=> "position", :conditions=> :institution == current_user.institution)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenarios }
    end
   
  end


  def show
    @scenario = Scenario.find(params[:id])
  end

  def new

    @scenario = Scenario.new
    
    respond_to do |format|
      format.html
      format.xml { render :xml=> @users }
    end
    
  end
  
  def create
    
    @scenario = Scenario.new(params[:scenario])
    
    #regardless of what's passed in, if user isn't superadmin set institution to user's institution
    if current_user.role.name!="superadmin"
      @scenario.institution = current_user.institution
    end
    
    
    # Due to the fact that scenarios must be "preloaded" with system variables, when a  
    # user creates a scenario we create the join table entries on saving. Is this crazy? I don't know.
    # Below we create entries in the join table for all existing system variables. 
    # While we're at it, add in the specific attributes for the join table entry as defaults
    
    if @scenario.save
    
      sysVars = Systemvariable.find(:all, :order=>'component_id, typeID, is_fault, global_disable, name' )
    
      sysVars.each do |sysVar| 
      
        s = ScenarioSystemvariable.new()
        s.scenario_id = @scenario.id
        s.systemvariable_id = sysVar.id
        s.disabled = sysVar.global_disable
        s.low_value = sysVar.min_value
        s.high_value = sysVar.max_value
        s.initial_value = sysVar.default_value
        s.save!

      end
  
      respond_to do |format|
        format.html { redirect_to(scenarios_url) }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
      end
    
    else
      
      respond_to do |format|
        flash[:error] = 'Couldn\'t create scenario'
        format.html { render :action => "new" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
      
    end
    
  end


  def edit
    @scenario = Scenario.find(params[:id])
  end

  def update

    #debugger 

    @scenario = Scenario.find(params[:id])
		
    if @scenario.update_attributes(params[:scenario])

      #If user is superadmin, check the institution parameter
      
      if current_user.role.name=="superadmin" && params[:institution_id]
        @scenario.institution = Institution.find(params[:institution_id])
      end
				
      flash[:notice] = 'Scenario was successfully updated.'
      
      respond_to do |format|
        format.html { redirect_to(scenarios_url) }
        format.xml  { head :ok }
      end
      
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
    
    
  rescue ActiveRecord::StaleObjectError
      flash.now[:notice] = 'Conflict Error'
      render :action => 'conflict'
  end

  
  def editsysvars
    @scenario = Scenario.find(params[:id])
    
  end
  
  def updatesysvars
    
    @scenario = Scenario.find(params[:id])
    
    @scenario.scenario_systemvariables.each do |sysVar|
			  
      applicationID  = params["applicationID"+sysVar.id.to_s]
      disabled  = params["disabled"+sysVar.id.to_s]
      low_value  = params["low_value"+sysVar.id.to_s]
      initial_value  = params["initial_value"+sysVar.id.to_s]
      high_value  = params["high_value"+sysVar.id.to_s]
  		
      sysVar.applicationID  = applicationID if applicationID != nil
      if disabled == nil or disabled == false
        sysVar.disabled = false
      else
        sysVar.disabled = true
      end
        
      sysVar.low_value  = low_value if low_value != nil
      sysVar.initial_value  =  initial_value if initial_value != nil
      sysVar.high_value  = high_value if high_value != nil       
      sysVar.save!
	    
    end
    
    flash[:notice] = 'Scenario variables were successfully updated.'
    
    
  	redirect_to :action=>:index
    
    #respond_to do |format|
    #  format.html { redirect_to(scenarios_url) }
    #  format.xml  { head :ok }
    #end
    
  end
  
  def duplicate
		
		# Create a duplicate scenario, append COPY to name
		scenario_to_dup = Scenario.find(params[:id])
  	new_scenario = scenario_to_dup.clone()
  	new_scenario.scenID = scenario_to_dup.scenID + "COPY"
		
		# Make sure to copy related system variables
		new_configs = []
		for config in scenario_to_dup.scenario_systemvariables
			new_configs << config.clone
		end
		   
		new_scenario.scenario_systemvariables << new_configs
		if new_scenario.save()
      flash[:notice] = 'Scenario was successfully duplicated'
  	else
  	  flash[:notice] = 'Scenario could not be successfully duplicated'
  	end
  	
  	redirect_to :action=>:index
	
	end
	
	#move a scenario up one row closer to 1 in sort list
	def sort_up 
	  s = Scenario.find(params[:id])
	  s.move_higher
	  redirect_to :action=>:index 
	end
  
	#move a scenario down one row away from 1 in sort list
  def sort_down
	  s = Scenario.find(params[:id])
	  s.move_lower
	  redirect_to :action=>:index
  end

  def destroy
    @scenario = Scenario.find(params[:id])
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to(scenarios_url) }
      format.xml  { head :ok }
    end
  end
  
  #Return an XML representation of a scenario
  def genXML
    
    scenario = Scenario.find(params[:id])
    xml = scenario.get_xml
    render :xml=> xml
    
  end
  

  
end
