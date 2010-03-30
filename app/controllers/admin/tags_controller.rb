class Admin::TagsController < ApplicationController
  
  def index
    if params[:term]
      @tags = MasterScenario.tagged_like(params[:term].split(",").last.strip)
    end
    
    render :js => @tags.try(:to_json) || []
  end
  
end
