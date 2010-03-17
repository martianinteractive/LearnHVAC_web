module ApplicationHelper
  
  def display_flash
    return %Q[<div class="notice">#{h(flash[:notice])}</div>] if flash[:notice]
    return %Q[<div class="error">#{h(flash[:error])}</div>] if flash[:error]
    return %Q[<div class="warning">#{h(flash[:warning])}</div>] if flash[:warning]
  end
  
end
