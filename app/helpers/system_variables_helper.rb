module SystemVariablesHelper
  
  def filter_select_for(field, collection)
    current = params[:filter][field] if params[:filter]
    content_tag(:form, :action => admins_master_scenario_system_variables_path, :method => :get) do 
      select_tag "filter[#{field}]", options_for_select(%w(Any) + collection, current), :class => "filter"
    end
  end
  
end
