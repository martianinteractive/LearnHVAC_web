# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def select_with_integer_options (object, column, start, stop, default = nil)  
    output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
    for i in start..stop  
      output << "\n<option value=\"#{i}\""  
      output << " selected=\"selected\"" if i == default  
      output << ">#{i}"  
    end  
    output + "</select>"  
   end  
end
