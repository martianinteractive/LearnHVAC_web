module ApplicationHelper

  def mail_to(email_address, name = nil, html_options = {})
    email_address = email_address.join ',' if email_address.is_a? Array
    super(email_address, name, html_options)
  end

  def display_flash
    return content_tag("div", flash[:notice], :class => "flash alert-message success")  if flash[:notice]
    return content_tag("div", flash[:error], :class => "flash alert-message error")  if flash[:error]
    return content_tag("div", flash[:warning], :class => "flash alert-message warning") if flash[:warning]
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

  def sidebar_menu
    html    = ''
    title   = 'Classes' if current_section == :groups
    title   ||= current_section.to_s.titleize
    options = sidebar_nav_options[current_namespace][current_section]
    html << generate_sidebar_section(title, options)
    html.html_safe
  end

  def main_menu_items
    items = ''
    {
      :admins => {
        :general  => admins_dashboard_path,
        :system   => admins_master_scenarios_path,
        :users    => admins_users_path(:role => :user)
      },
      :instructors => {
        :dashboard  => instructors_dashboard_path,
        :scenarios  => instructors_scenarios_path,
        :classes    => instructors_classes_path
      },
      :managers => {
        :dashboard    => managers_dashboard_path,
        :instructors  => managers_instructors_path,
        :classes      => managers_classes_path,
        :scenarios    => managers_scenarios_path
      },
      :students => {
        :classes => students_classes_path
      },
      :guests => {
        :dashboard => guests_dashboard_path
      }
    }[current_namespace].each_pair do |title, url|
      li_options = {}
      if :classes === title
        li_options.merge! :class => 'active' if is_current_item? :groups
      else
        li_options.merge! :class => 'active' if is_current_item? title
      end
      items << content_tag(:li, link_to(title.to_s.titleize, url), li_options )
    end
    items.html_safe
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

  def current_namespace
    namespace = params[:controller].match(/\w+/)[0]
    if current_user
      @current_namespace = current_user.role.to_s.pluralize.to_sym
    elsif namespace
      @current_namespace = namespace.to_sym
    else
      @current_namespace = :guest
    end
    @current_namespace
  end

  def current_section
    sections[current_namespace].each_pair do |section, controllers|
      @current_section ||= section if controllers.include? controller_name
    end
    @current_section
  end

  def sections
    @sections ||= {
      :admins => {
        :general => %w[ dashboard dashboards settings client_versions educational_entities ],
        :system  => %w[ access master_scenarios scenarios system_variables variables ],
        :users   => %w[ users groups institutions ],
        :profile => %w[ users ]
      },
      :instructors => {
        :dashboard  => %w[ dashboards ],
        :scenarios  => %w[ scenarios shared_scenarios access variables ],
        :groups     => %w[ groups emails ],
        :profile => %w[ users ]
      },
      :managers => {
        :dashboard    => %w[ dashboards ],
        :groups       => %w[ groups ],
        :scenarios    => %w[ scenarios variables access ],
        :instructors  => %w[ instructors ]
      },
      :students => {
        :groups => %w[ groups ],
        :profile => %w[ users ]
      },
      :guests => {
        :dashboard => %w[ dashboard ],
        :profile => %w[ users ]
      }
    }
  end

  def is_current_item?(name)
    controllers = sections[current_namespace][name]
    controllers.include? controller_name if controllers
  end

  def sidebar_nav_options
    @sidebar_nav_options = {
      :guests => {
        :dashboard => [
          {
            :link  => guests_dashboard_path,
            :value => 'Dashboard'
          }
        ],
        :profile => [
          {
            :link  => guests_dashboard_path,
            :value => 'Dashboard'
          }
        ]
      },
      :admins => {
        :profile => [
          {
            :link   => admins_dashboard_path,
            :value  => 'Dashboard'
          }
        ],
        :general => [
          {
            :link   => admins_dashboard_path,
            :value  => 'Dashboard'
          },
          {
            :link   => admins_settings_path,
            :value  => 'Settings'
          }
        ],
        :system => [
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
      },
      :instructors => {
        :profile => [
          {
            :link   => instructors_dashboard_path,
            :value  => 'Dashboard'
          }
        ],
        :dashboard => [
          {
            :link   => instructors_scenarios_path,
            :value  => 'Scenarios'
          },
          {
            :link   => instructors_classes_path,
            :value  => 'Classes'
          }
        ],
        :scenarios => [
          {
            :link   => instructors_scenarios_path,
            :value  => 'Scenarios'
          },
          {
            :link   => instructors_shared_scenarios_path,
            :value  => 'Shared Scenarios'
          },
          {
            :link   => new_instructors_scenario_path,
            :value  => 'New Scenario'
          }
        ],
        :groups => [
          {
            :link   => '#',
            :value  => 'Classes'
          },
          {
            :link   => '#',
            :value  => 'New Class'
          }
        ]
      },
      :students => {
        :groups => [
          {
            :link => students_classes_path,
            :value => 'Classes'
          }
        ],
        :profile => [
          {
            :link => students_classes_path,
            :value => 'Classes'
          }
        ]
      },
      :managers => {
        :dashboard => [
          {
            :link   => managers_instructors_path,
            :value  => 'Instructors'
          },
          {
            :link   => managers_classes_path,
            :value  => 'Classes'
          },
          {
            :link   => managers_scenarios_path,
            :value  => 'Scenarios'
          }
        ],
        :instructors => [
          {
            :link   => managers_instructors_path,
            :value  => 'Instructors'
          },
          {
            :link   => new_managers_instructor_path,
            :value  => 'New Instructor'
          }
        ],
        :groups => [
          {
            :link   => managers_classes_path,
            :value  => 'Classes'
          },
          {
            :link   => new_managers_class_path,
            :value  => 'New Class'
          }
        ],
        :scenarios => [
          {
            :link   => managers_scenarios_path,
            :value  => 'Scenarios'
          },
          {
            :link   => new_managers_scenario_path,
            :value  => 'New Scenario'
          }
        ]
      }
    }
  end

end
