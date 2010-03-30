class Admin::TagsController < ApplicationController
  
  def index
    if params[:term]
      term = params[:term].split(",").last.strip
      @tags = MasterScenario.tagged_like(term)
    end
    
    if @tags.any?
      render :js => @tags.to_json
    else
      render :nothing => true
    end
  end
  
end
