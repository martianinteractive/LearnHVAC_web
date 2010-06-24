class PostLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
  
  protected
  
  def page_number(page)
    unless page == current_page
      link(page, page, :rel => rel_value(page), 'data-method' => :post)
    else
      tag(:em, page)
    end
  end
  
  def previous_or_next_page(page, text, classname)
    if page
      link(text, page, :class => classname, 'data-method' => :post)
    else
      tag(:span, text, :class => classname + ' disabled')
    end
  end
end