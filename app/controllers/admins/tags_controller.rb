class Admins::TagsController < Admins::ApplicationController
  
  def index
    @tags = MasterScenario.tagged_like(params[:term].split(",").last.strip) if params[:term]
    render :js => @tags.try(:to_json) || []
  end
  
end
