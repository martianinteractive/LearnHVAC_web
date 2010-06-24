module SystemVariablesHelper
  
  def filter_select_for(field, collection)
    current = params[:filter][field] if params[:filter]
    select_tag "filter[#{field}]", options_for_select(collection, current), :class => "filter"
  end
  
end
