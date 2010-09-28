module Admins::EducationalEntitiesHelper
  
  def paginate
    if params[:action] == "index"
      will_paginate @colleges
    else
      will_paginate @colleges, :renderer => "PostLinkRenderer", :params => { :q => params[:q] }
    end
  end
  
end
