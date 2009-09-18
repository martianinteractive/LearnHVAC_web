

require 'faster_csv'

class SystemvariablesController < ApplicationController
    
  before_filter :login_required
  
  def index
    
		if defined? params["component"]["id"] and params["component"]["id"] != "0"  
		  @systemvariables = Systemvariable.find(:all, 
			                                       :conditions => ["component_id = ?", params["component"]["id"]], 
			                                       :order=>'is_fault, typeID, name',
			                                       :include=>:component)
			@componentFilterID = params["component"]["id"]
		else
		   @systemvariables = Systemvariable.find(:all,
			                                       :order=>'component_id, is_fault, typeID, name',
			                                       :include=>:component)
		end
		
		components = Component.find(:all) 
		@componentFilter = components.map{ |a| [a.name, a.id] }
		@componentFilter.unshift(['(all)', '0'])
		
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @systemvariables }
    end
    
  end

  def show
    @systemvariable = Systemvariable.find(params[:id])
  end

  def new
    
    if current_user.role.name != "superadmin"
      flash[:notice] = 'You do not have permission to create new system variables.'
      redirect_to :action => 'index'
    end
    @systemvariable = Systemvariable.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @systemvariable }
    end
  end


  def create
    
    if current_user.role.name != "superadmin"
      flash[:notice] = 'You do not have permission to create new system variables.'
      redirect_to :action => 'index'
    end
    
    @systemvariable = Systemvariable.new(params[:systemvariable])
    
    respond_to do |format|
      if @systemvariable.save
      
        #Add system variable to all existing scenarios by adding to join table
        scenarios = Scenario.find(:all)
      
        for scenario in scenarios
        
          newSystemVariable = ScenarioSystemvariable.new(
                :scenario=>scenario,
                :systemvariable => @systemvariable,
  							:low_value => @systemvariable.min_value,
  							:initial_value => @systemvariable.default_value,
  							:high_value => @systemvariable.max_value
  							)
          newSystemVariable.save
        end
        
        flash[:notice] = 'Systemvariable was successfully created.'
        format.html {redirect_to(systemvariables_url)}
        format.xml {render :xml=>@systemvariable, :status=> :created, :location=>@systemvariable}
    
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @systemvariable.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  
  
  def edit
    
    if current_user.role.name != "superadmin"
      flash[:notice] = 'You do not have permission to edit new system variables.'
      redirect_to :action => 'index'
    end
    
    @systemvariable = Systemvariable.find(params[:id])
    
  end

  def update
  
    if current_user.role.name != "superadmin"
      flash[:notice] = 'You do not have permission to edit new system variables.'
      redirect_to :action => 'index'
    end
    
    @systemvariable = Systemvariable.find(params[:id])
    
    respond_to do |format|
      
      if @systemvariable.update_attributes(params[:systemvariable])
        flash[:notice] = 'Systemvariable was successfully updated.'
        format.html { redirect_to(systemvariables_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @systemvariable.errors, :status => :unprocessable_entity }
      end
      
    end
  
  rescue ActiveRecord::StaleObjectError
      flash.now[:notice] = 'Conflict Error'
      render :action => 'conflict'  
  end
    

  def destroy
    
    if current_user.role.name != "superadmin"
      flash[:notice] = 'You do not have permission to edit new system variables.'
      redirect_to :action => 'index'
    end
    
    @sysVar = Systemvariable.find(params[:id])
    
    #destroy all entries in scenario_systemvariables join table
    ScenarioSystemvariable.destroy_all(["systemvariable_id = ?", @sysVar.id]) #is there a more rails way to do this?
    
    @sysVar.destroy
    flash[:notice] = 'Systemvariable was successfully destroyed.'

    respond_to do |format|
      format.html { redirect_to(systemvariables_url) }
      format.xml  { head :ok }
    end
  end

  def dumpCSV
    systemvariables = Systemvariable.find(:all)
    stream_csv do |csv|
      csv << ["id","name","display name","min value","default value", "max value","component_id","description","typeID","unit_si","unit_ip","si_to_ip","is_fault","left_label","right_label","subsection","zone_position","is_percentage","fault_widget_type","notes"]
      systemvariables.each do |s|
        csv << [s.id, s.name, s.display_name, s.min_value, s.default_value, s.max_value, s.component_id, s.description, s.typeID, s.unit_si, s.unit_ip, s.si_to_ip, s.is_fault, s.left_label, s.right_label, s.subsection, s.zone_position, s.is_percentage, s.fault_widget_type, s.notes]
      end
    end
  end 

  private

    def stream_csv
       filename = params[:action] + ".csv"    

       #this is required if you want this to work with IE        
       if request.env['HTTP_USER_AGENT'] =~ /msie/i
         headers['Pragma'] = 'public'
         headers["Content-type"] = "text/plain" 
         headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
         headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
         headers['Expires'] = "0" 
       else
         headers["Content-Type"] ||= 'text/csv'
         headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
       end

      render :text => Proc.new { |response, output|
        csv = FasterCSV.new(output, :row_sep => "\r\n") 
        yield csv
      }
    end



end
