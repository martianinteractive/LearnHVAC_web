module VariablesHelper
  
  def filter_select_for(field, collection)
    current = params[:filter][field] if params[:filter]
    select_tag "filter[#{field}]", options_for_select(%w(Any) + collection, current), :class => "filter"
  end
  
end
