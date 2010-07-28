class Admins::TagsController < Admins::ApplicationController
  
  def index
    last_tag = params[:term].split(",").last.strip if params[:term]
    @tags = Tag.where(["name like ?", "#{last_tag}%"])
    render :js => @tags.collect{|t| t.name}.to_json
  end
  
end
