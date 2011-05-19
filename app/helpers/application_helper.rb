module ApplicationHelper
  
  def nav_fields
    @nav_fields ||= [
      {:title => 'Users', :id => 'nav_users', :path => admins_users_path(:role => 'instructor'), :order => 1, :authorized_roles => [:admin]}
    ]
  end

  def generate_nav
    nav_items(nav_fields, @title)
  end

  def nav_items(entries, match_tab)
    ''.html_safe.tap do |items|
      entries.sort_by {|f| f[:order]}.each do |field|
        if field[:authorized_roles].include?(current_user.role)
          link_options = field[:rel].blank? ? {:id => field[:id]} : {:rel => field[:rel], :id => field[:id]}
          link_options.merge!(field[:title] == match_tab.to_s ? {:class => 'button current'} :  {:class => 'button'})
          items << (field[:path].blank? ? field[:title] : link_to(field[:title], field[:path], link_options))
        end
      end
    end
  end
    
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
  
  def search_pagination_for(collection, opts={})
    if params[:action] == "index"
      will_paginate collection
    else
      defaults = {:renderer => "PostLinkRenderer", :params => { :q => params[:q] }}
      will_paginate collection, defaults.merge(opts)
    end
  end
  
  
end
