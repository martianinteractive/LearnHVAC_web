module ApplicationHelper
  
  def display_flash
    return content_tag("div", flash[:notice], :class => "notice")  if flash[:notice]
    return content_tag("div", flash[:error], :class => "error")  if flash[:error]
    return content_tag("div", flash[:warning], :class => "warning") if flash[:warning]
  end
  
  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new if method
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f 
    template = form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f, :show_delete => true })
    end
    template.html_safe
  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end
  
end
