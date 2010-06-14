class Admins::ScenariosController < Admins::ApplicationController
    add_crumb("Instructor Scenarios") { |instance| instance.send :admins_scenarios_path }
  
   def index
     @scenarios = Scenario.paginate :page => params[:page], :per_page => 25
   end
   
   def list
     @scenarios = User.find(params[:user_id]).scenarios if params[:user_id].present?
     render :layout => false
   end

   def show
     @scenario = Scenario.find(params[:id])
     add_crumb @scenario.name, admins_scenario_path(@scenario)
   end
   
   def observers
     @scenario = Scenario.find(params[:id])
   end

   def new
     @scenario = Scenario.new
     add_crumb "New Scenario", new_admins_scenario_path
   end

   def edit
     @scenario = Scenario.find(params[:id])
     add_crumb "Editing #{@scenario.name}", edit_admins_scenario_path(@scenario)
   end

   def create
     @scenario = Scenario.new(params[:scenario])
     # Add attr_protected :user_id to scenario.
     @scenario.user = User.find(params[:scenario][:user_id])
     
     if @scenario.save
       redirect_to(admins_scenario_path(@scenario), :notice => 'Scenarios was succesfully created.')
     else
       render :action => "new"
     end
   end

   def update
     @scenario = Scenario.find(params[:id])
     @scenario.user = User.find(params[:scenario][:user_id])
     
     if @scenario.update_attributes(params[:scenario])
       redirect_to(admins_scenario_path(@scenario), :notice => 'Scenarios was succesfully udpated.')
     else
       add_crumb "Editing #{@scenario.name}", edit_admins_scenario_path(@scenario)
       render :action => "edit"
     end
   end

   def destroy
     @scenario = Scenario.find(params[:id])
     
     @scenario.destroy
     redirect_to(admins_scenarios_url)
   end
end
