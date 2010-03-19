class Admin::ScenariosController < ApplicationController
  before_filter :require_admin
  layout "admin"
  
  def index
     @scenarios = Scenario.all
   end

   def show
     @scenario = Scenario.find(params[:id])
   end

   def new
     @scenario = Scenario.new
   end

   def edit
     @scenario = Scenario.find(params[:id])
   end

   def create
     @scenario = Scenario.new(params[:scenario])

     if @scenario.save
       redirect_to(@scenario, :notice => 'Scenario was successfully created.')
     else
       render :action => "new"
     end
   end

   def update
     @scenario = Scenario.find(params[:id])
     
     if @scenario.update_attributes(params[:scenario])
       redirect_to(@scenario, :notice => 'Scenario was successfully updated.')
     else
       render :action => "edit"
     end
   end

   def destroy
     @scenario = Scenario.find(params[:id])
     
     @scenario.destroy
     redirect_to(scenarios_url)
   end
end
