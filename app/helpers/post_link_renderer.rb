class PostLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
  
  private
  
  def link(text, target, attributes = {})
    if target.is_a? Fixnum
      attributes[:rel] = rel_value(target)
      target = url(target)
    end
    attributes[:href] = target
    attributes["data-method"] = "post"
    attributes[:rel] = "nofollow"
    tag(:a, text, attributes)
  end
  
end