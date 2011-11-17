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

  def search_pagination_for(collection, opts={})
    if params[:action] == "index"
      will_paginate collection
    else
      defaults = {:renderer => "PostLinkRenderer", :params => { :q => params[:q] }}
      will_paginate collection, defaults.merge(opts)
    end
  end

  def main_menu
    content_tag :ul, main_menu_items, :class => 'nav'
  end

  def main_menu_items
    items = ''
    {
      :general  => admins_dashboard_path,
      :system   => admins_master_scenarios_path,
      :users    => admins_users_path(:role => :user)
    }.each_pair do |title, url|
      li_options = {}
      li_options.merge! :class => 'active' if is_current_item? title
      items << content_tag(:li, link_to(title.to_s.titleize, url), li_options )
    end
    items.html_safe
  end

  def is_current_item?(title)
    {
      :general => %w[ dashboard ],
      :system  => %w[ master_scenarios scenarios ],
      :users   => %w[ users ]
    }[ title ].include? controller_name
  end

  def sidebar_menu
    html = ''
    sidebar_nav_options.each_pair do |key, options|
      html << generate_sidebar_section(key.to_s.titleize, options)
    end
    html.html_safe
  end

  def generate_sidebar_section(title, options)
    html = ''
    html << content_tag(:h5, title)
    html << sidebar_links(options)
  end

  def sidebar_links(elements)
    items = ''
    elements.each do |element|
      items << content_tag(:li, link_to(element[:value], element[:link]))
    end
    content_tag(:ul, items.html_safe).html_safe
  end

  def sidebar_nav_options
    @sidebar_nav_options = {
      :general => [
        {
          :link   => admins_dashboard_path,
          :value  => 'Dashboard'
        },
        {
          :link   => admins_settings_path,
          :value  => 'Settings'
        },
        {
          :link   => directory_path,
          :value  => 'Community Directory'
        }
      ],
      :system => [
        {
          :link   => new_admins_master_scenario_path,
          :value  => 'New Master Scenarios'
        },
        {
          :link   => admins_master_scenarios_path,
          :value  => 'Master Scenarios'
        },
        {
          :link   => admins_scenarios_path,
          :value  => 'Instructor Scenarios'
        }
      ],
      :users => [
        {
          :link   => admins_users_path(:role => :admin),
          :value  => 'Admins'
        },
        {
          :link   => admins_users_path(:role => :manager),
          :value  => 'Inst. Managers'
        },
        {
          :link   => admins_users_path(:role => :instructor),
          :value  => 'Instructors'
        },
        {
          :link   => admins_users_path(:role => :student),
          :value  => 'Students'
        },
        {
          :link   => admins_users_path(:role => :guest),
          :value  => 'Guests'
        },
        {
          :link   => admins_institutions_path,
          :value  => 'Institutions'
        },
        {
          :link   => admins_classes_path,
          :value  => 'Classes'
        }
      ]
    }
  end

end
