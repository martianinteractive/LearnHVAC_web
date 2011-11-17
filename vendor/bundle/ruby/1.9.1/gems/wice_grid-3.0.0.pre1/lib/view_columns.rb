# encoding: UTF-8
module Wice

  class ViewColumn  #:nodoc:
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::AssetTagHelper

    # fields defined from the options parameter
    FIELDS = [:attribute_name, :column_name, :td_html_attrs, :no_filter, :model_class, :allow_multiple_selection,
              :in_html, :in_csv, :helper_style, :table_alias, :custom_order, :detach_with_id, :allow_ordering, :auto_reload]

    attr_accessor *FIELDS

    attr_accessor :cell_rendering_block, :grid, :css_class, :table_name, :main_table, :model_class, :custom_filter

    attr_reader :contains_a_text_input

    def initialize(block, options, grid_obj, tname, mtable, cfilter, view)  #:nodoc:
      self.cell_rendering_block = block
      self.grid           = grid_obj
      self.table_name     = tname
      self.main_table     = mtable
      self.custom_filter  = cfilter
      @view = view

      FIELDS.each do |field|
        self.send(field.to_s + '=', options[field])
      end
    end

    cattr_accessor :handled_type
    @@handled_type = Hash.new

    def css_class #:nodoc:
      @css_class || ''
    end

    def yield_declaration_of_column_filter #:nodoc:
      nil
    end

    def detachness #:nodoc:
      (! detach_with_id.blank?).to_s
    end

    def yield_javascript #:nodoc:
      declaration = yield_declaration_of_column_filter
      if declaration
        %!#{@grid.name}.register( {
          filter_name : "#{self.column_name}",
          detached : #{detachness},
          #{declaration}
        } ); !
      else
        ''
      end
    end


    def config  #:nodoc:
      @view.config
    end

    def controller  #:nodoc:
      @view.controller
    end


    def render_filter #:nodoc:
      params = @grid.filter_params(self)
      res = render_filter_internal(params)
      return (res.is_a?(Array)) ? res : [res, nil]
    end

    def render_filter_internal(params) #:nodoc:
      '<!-- implement me! -->'
    end

    def form_parameter_name_id_and_query(v) #:nodoc:
      query = form_parameter_template(v)
      query_without_equals_sign = query.sub(/=$/,'')
      parameter_name = CGI.unescape(query_without_equals_sign)
      dom_id = id_out_of_name(parameter_name)
      return query, query_without_equals_sign, parameter_name, dom_id.tr('.', '_')
    end

    # bad name, because for the main table the name is not really 'fully_qualified'
    def attribute_name_fully_qualified_for_all_but_main_table_columns #:nodoc:
      self.main_table ? attribute_name : table_alias_or_table_name + '.' + attribute_name
    end

    def fully_qualified_attribute_name #:nodoc:
      table_alias_or_table_name + '.' + attribute_name
    end


    def filter_shown? #:nodoc:
      self.attribute_name && ! self.no_filter
    end

    def filter_shown_in_main_table? #:nodoc:
      filter_shown? && ! self.detach_with_id
    end


    def table_alias_or_table_name  #:nodoc:
      table_alias || table_name
    end

    def capable_of_hosting_filter_related_icons?  #:nodoc:
      self.attribute_name.blank? && self.column_name.blank? && ! self.filter_shown?
    end

    def has_auto_reloading_input?  #:nodoc:
      false
    end

    def auto_reloading_input_with_negation_checkbox?  #:nodoc:
      false
    end

    def has_auto_reloading_select?  #:nodoc:
      false
    end

    def has_auto_reloading_calendar?  #:nodoc:
      false
    end

    protected

    def form_parameter_template(v) #:nodoc:
      {@grid.name => {:f => {self.attribute_name_fully_qualified_for_all_but_main_table_columns => v}}}.to_query
    end

    def form_parameter_name(v) #:nodoc:
      form_parameter_template_hash(v).to_query
    end

    def name_out_of_template(s) #:nodoc:
      CGI.unescape(s).sub(/=$/,'')
    end

    def id_out_of_name(s) #:nodoc:
      s.gsub(/[\[\]]+/,'_').sub(/_+$/, '')
    end

  end

  class ActionViewColumn < ViewColumn #:nodoc:
    def initialize(grid_obj, td_html_attrs, param_name, select_all_buttons, object_property, view)  #:nodoc:
      @view = view
      @select_all_buttons   = select_all_buttons
      self.grid             = grid_obj
      self.td_html_attrs    = td_html_attrs
      self.td_html_attrs.add_or_append_class_value!('sel')
      grid_name             = self.grid.name
      @param_name           = param_name
      @cell_rendering_block = lambda do |object, params|
        selected = if params[grid_name] && params[grid_name][param_name] &&
                      params[grid_name][param_name].index(object.send(object_property).to_s)
          true
        else
          false
        end
        check_box_tag("#{grid_name}[#{param_name}][]", object.send(object_property), selected, :id => nil)
      end
    end

    def in_html  #:nodoc:
      true
    end

    def capable_of_hosting_filter_related_icons?  #:nodoc:
      false
    end

    def column_name  #:nodoc:
      return '' unless @select_all_buttons
      select_all_tootip   = WiceGridNlMessageProvider.get_message(:SELECT_ALL)
      deselect_all_tootip = WiceGridNlMessageProvider.get_message(:DESELECT_ALL)

      html = content_tag(:span, image_tag(Defaults::TICK_ALL_ICON, :alt => select_all_tootip),
                         :class => 'clickable select_all', :title => select_all_tootip) + ' ' +
             content_tag(:span, image_tag(Defaults::UNTICK_ALL_ICON, :alt => deselect_all_tootip),
                         :class => 'clickable deselect_all', :title => deselect_all_tootip)

      js = JsAdaptor.action_column_initialization(grid.name)

      [html, js]
    end

  end

  class ViewColumnInteger < ViewColumn #:nodoc:
    @@handled_type[:integer] = self

    def render_filter_internal(params) #:nodoc:
      @contains_a_text_input = true

      @query, _, parameter_name, @dom_id = form_parameter_name_id_and_query(:fr => '')
      @query2, _, parameter_name2, @dom_id2 = form_parameter_name_id_and_query(:to => '')

      opts1 = {:size => 3, :id => @dom_id}
      opts2 = {:size => 3, :id => @dom_id2}

      if auto_reload
        opts1[:class] = ' auto_reload'
        opts2[:class] = ' auto_reload'
      end

      text_field_tag(parameter_name,  params[:fr], opts1) + text_field_tag(parameter_name2, params[:to], opts2)
    end

    def yield_declaration_of_column_filter #:nodoc:
      %$templates : ['#{@query}', '#{@query2}'],
          ids : ['#{@dom_id}', '#{@dom_id2}']  $
    end

    def has_auto_reloading_input? #:nodoc:
      auto_reload
    end

  end

  class ViewColumnFloat < ViewColumnInteger #:nodoc:
    @@handled_type[:decimal] = self
    @@handled_type[:float] = self
  end

  class ViewColumnCustomDropdown < ViewColumn #:nodoc:
    include ActionView::Helpers::FormOptionsHelper

    attr_accessor :filter_all_label
    attr_accessor :custom_filter

    def render_filter_internal(params) #:nodoc:
      @query, @query_without_equals_sign, @parameter_name, @dom_id = form_parameter_name_id_and_query('')
      @query_without_equals_sign += '%5B%5D='

      @custom_filter = @custom_filter.call if @custom_filter.kind_of? Proc

      if @custom_filter.kind_of? Array

        @custom_filter = [[@filter_all_label, nil]] + @custom_filter.map{|label, value|
          [label.to_s, value.to_s]
        }

      end

      select_options = {:name => @parameter_name, :id => @dom_id, :class => 'custom_dropdown'}

      if @turn_off_select_toggling
        select_toggle = ''
      else
        if self.allow_multiple_selection
          select_options[:multiple] = params.is_a?(Array) && params.size > 1
          select_toggle = content_tag(:a,
            tag(:img, :alt => 'Expand/Collapse', :src => Defaults::TOGGLE_MULTI_SELECT_ICON),
            :href => "javascript: toggle_multi_select('#{@dom_id}', this, 'Expand', 'Collapse');", # TO DO: to locales
            :class => 'toggle_multi_select_icon', :title => 'Expand')
        else
          select_options[:multiple] = false
          select_toggle = ''
        end
      end

      if auto_reload
        select_options[:class] += ' auto_reload'
      end

      params_for_select = (params.is_a?(Hash) && params.empty?) ? [nil] : params

      '<span class="custom_dropdown_container">'.html_safe_if_necessary +
        content_tag(:select,
          options_for_select(@custom_filter, params_for_select),
          select_options) +
      select_toggle.html_safe_if_necessary + '</span>'.html_safe_if_necessary
    end

    def yield_declaration_of_column_filter #:nodoc:
      %$templates : ['#{@query_without_equals_sign}'],
          ids : ['#{@dom_id}']  $
    end

    def has_auto_reloading_select? #:nodoc:
      auto_reload
    end
  end

  class ViewColumnBoolean < ViewColumnCustomDropdown #:nodoc:
    @@handled_type[:boolean] = self
    include ActionView::Helpers::FormOptionsHelper

    attr_accessor :boolean_filter_true_label, :boolean_filter_false_label

    def render_filter_internal(params) #:nodoc:
      @custom_filter = {
        @filter_all_label => nil,
        @boolean_filter_true_label  => 't',
        @boolean_filter_false_label => 'f'
      }

      @turn_off_select_toggling = true
      super(params)
    end
  end

  class ViewColumnDatetime < ViewColumn #:nodoc:
    @@handled_type[:datetime] = self
    @@handled_type[:timestamp] = self
    include ActionView::Helpers::DateHelper
    include Wice::JsCalendarHelpers


    # name_and_id_from_options in Rails Date helper does not substitute '.' with '_'
    # like all other simpler form helpers do. Thus, overriding it here.
    def name_and_id_from_options(options, type)  #:nodoc:
      options[:name] = (options[:prefix] || DEFAULT_PREFIX) + (options[:discard_type] ? '' : "[#{type}]")
      options[:id] = options[:name].gsub(/([\[\(])|(\]\[)/, '_').gsub(/[\]\)]/, '').gsub(/\./, '_').gsub(/_+/, '_')
    end

    @@datetime_chunk_names = %w(year month day hour minute)

    def prepare_for_standard_filter #:nodoc:
      x = lambda{|sym|
        @@datetime_chunk_names.collect{|datetime_chunk_name|
          triple = form_parameter_name_id_and_query(sym => {datetime_chunk_name => ''})
          [triple[0], triple[3]]
        }
      }

      @queris_ids = x.call(:fr) + x.call(:to)

      _, _, @name1, _ = form_parameter_name_id_and_query({:fr => ''})
      _, _, @name2, _ = form_parameter_name_id_and_query({:to => ''})
    end


    def prepare_for_calendar_filter #:nodoc:
      query, _, @name1, @dom_id = form_parameter_name_id_and_query(:fr => '')
      query2, _, @name2, @dom_id2 = form_parameter_name_id_and_query(:to => '')

      @queris_ids = [[query, @dom_id], [query2, @dom_id2] ]
    end


    def render_standard_filter_internal(params) #:nodoc:
      '<div class="date-filter">' +
      select_datetime(params[:fr], {:include_blank => true, :prefix => @name1}) + '<br/>' +
      select_datetime(params[:to], {:include_blank => true, :prefix => @name2}) +
      '</div>'
    end

    def render_calendar_filter_internal(params) #:nodoc:
      html1, js1 = datetime_calendar_prototype(params[:fr], @view,
        {:include_blank => true, :prefix => @name1, :id => @dom_id, :fire_event => auto_reload},
        :title => WiceGridNlMessageProvider.get_message(:DATE_SELECTOR_TOOLTIP_FROM))
      html2, js2 = datetime_calendar_prototype(params[:to], @view,
        {:include_blank => true, :prefix => @name2, :id => @dom_id2, :fire_event => auto_reload},
        :title => WiceGridNlMessageProvider.get_message(:DATE_SELECTOR_TOOLTIP_TO))
      [%!<div class="date-filter">#{html1}<br/>#{html2}</div>!, js1 + js2]
    end


    def render_filter_internal(params) #:nodoc:
      # falling back to the Rails helpers for Datetime
      if helper_style == :standard || Defaults::JS_FRAMEWORK == :jquery
        prepare_for_standard_filter
        render_standard_filter_internal(params)
      else
        prepare_for_calendar_filter
        render_calendar_filter_internal(params)
      end
    end

    def yield_declaration_of_column_filter #:nodoc:
      %$templates : [ #{@queris_ids.collect{|tuple| "'" + tuple[0] + "'"}.join(', ')} ],
          ids : [ #{@queris_ids.collect{|tuple| "'" + tuple[1] + "'"}.join(', ')} ] $
    end

    def has_auto_reloading_calendar? #:nodoc:
      auto_reload && helper_style == :calendar
    end

  end

  class ViewColumnDate < ViewColumnDatetime #:nodoc:
    @@handled_type[:date] = self

    @@datetime_chunk_names = %w(year month day)

    def render_standard_filter_internal(params) #:nodoc:
      '<div class="date-filter">' +
      select_date(params[:fr], {:include_blank => true, :prefix => @name1, :id => @dom_id}) + '<br/>' +
      select_date(params[:to], {:include_blank => true, :prefix => @name2, :id => @dom_id2}) +
      '</div>'
    end

    def render_calendar_filter_internal(params) #:nodoc:

      calendar_helper_method = if Wice::Defaults::JS_FRAMEWORK == :prototype
        :date_calendar_prototype
      else
        :date_calendar_jquery
      end

      html1, js1 = send(calendar_helper_method, params[:fr], @view,
        {:include_blank => true, :prefix => @name1, :fire_event => auto_reload},
        :title => WiceGridNlMessageProvider.get_message(:DATE_SELECTOR_TOOLTIP_FROM))
      html2, js2 = send(calendar_helper_method, params[:to], @view,
        {:include_blank => true, :prefix => @name2, :fire_event => auto_reload},
        :title => WiceGridNlMessageProvider.get_message(:DATE_SELECTOR_TOOLTIP_TO))

      [%!<div class="date-filter">#{html1}<br/>#{html2}</div>!, js1 + js2]
    end
    
    def render_filter_internal(params) #:nodoc:

      if helper_style == :standard
        prepare_for_standard_filter
        render_standard_filter_internal(params)
      else
        prepare_for_calendar_filter
        render_calendar_filter_internal(params)
      end
    end
  end

  class ViewColumnString < ViewColumn #:nodoc:
    @@handled_type[:string] = self
    @@handled_type[:text] = self

    attr_accessor :negation, :auto_reloading_input_with_negation_checkbox

    def render_filter_internal(params) #:nodoc:
      @contains_a_text_input = true
      css_class = auto_reload ? 'auto_reload' : nil

      if negation
        self.auto_reloading_input_with_negation_checkbox = true if auto_reload

        @query, _, parameter_name, @dom_id = form_parameter_name_id_and_query(:v => '')
        @query2, _, parameter_name2, @dom_id2 = form_parameter_name_id_and_query(:n => '')

        '<div class="text_filter_container">' +
          text_field_tag(parameter_name, params[:v], :size => 8, :id => @dom_id, :class => css_class) +
          if defined?(::Wice::Defaults::NEGATION_CHECKBOX_LABEL) && ! ::Wice::Defaults::NEGATION_CHECKBOX_LABEL.blank?
            ::Wice::Defaults::NEGATION_CHECKBOX_LABEL
          else
            ''
          end +
          check_box_tag(parameter_name2, '1', (params[:n] == '1'),
            :id => @dom_id2,
            :title => WiceGridNlMessageProvider.get_message(:NEGATION_CHECKBOX_TITLE),
            :class => 'negation_checkbox') +
          '</div>'
      else
        @query, _, parameter_name, @dom_id = form_parameter_name_id_and_query('')
        text_field_tag(parameter_name, (params.blank? ? '' : params), :size => 8, :id => @dom_id, :class => css_class)
      end
    end

    def yield_declaration_of_column_filter #:nodoc:
      if negation
        %$templates : ['#{@query}', '#{@query2}'],
            ids : ['#{@dom_id}', '#{@dom_id2}'] $
      else
        %$templates : ['#{@query}'],
            ids : ['#{@dom_id}'] $
      end
    end

    def has_auto_reloading_input? #:nodoc:
      auto_reload
    end

    def auto_reloading_input_with_negation_checkbox? #:nodoc:
      self.auto_reloading_input_with_negation_checkbox
    end

  end

end