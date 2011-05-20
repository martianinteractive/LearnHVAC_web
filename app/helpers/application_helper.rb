module ApplicationHelper
  
  def nav_fields
    @nav_fields ||= [
      {:title => 'Dashboard', :id => 'nav_dashboard', :path => admins_dashboard_path, :order => 1, :authorized_roles => [:admin]},
      {:title => 'Settings', :id => 'nav_settings', :path => admins_settings_path, :order => 1, :authorized_roles => [:admin]},
      {:title => 'Community Directory', :id => 'nav_community', :path => directory_path, :order => 1, :authorized_roles => [:admin]},
      {:title => 'Master Scenarios', :id => 'nav_master_scenario', :path => admins_master_scenarios_path, :order => 1, :authorized_roles => [:admin]},
      {:title => 'Inst. Scenarios', :id => 'nav_scenario', :path => admins_scenarios_path, :order => 1, :authorized_roles => [:admin]},
      {:title => 'Admins', :id => 'nav_admin', :path => admins_users_path(:role => :admin), :order => 1, :authorized_roles => [:admin]},
      {:title => 'Inst. Managers', :id => 'nav_inst_manager', :path => admins_users_path(:role => :manager), :order => 1, :authorized_roles => [:admin]},
      {:title => 'Instructors', :id => 'nav_instructors', :path => admins_users_path(:role => :instructor), :order => 1, :authorized_roles => [:admin]},
      {:title => 'Students', :id => 'nav_student', :path => admins_users_path(:role => :student), :order => 1, :authorized_roles => [:admin]},
      {:title => 'Guests', :id => 'nav_guests', :path => admins_users_path(:role => :guest), :order => 1, :authorized_roles => [:admin]},
      {:title => 'Institutions', :id => 'nav_institution', :path => admins_institutions_path, :order => 1, :authorized_roles => [:admin]},
      {:title => 'Classes', :id => 'nav_class', :path => admins_classes_path, :order => 1, :authorized_roles => [:admin]}]


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
