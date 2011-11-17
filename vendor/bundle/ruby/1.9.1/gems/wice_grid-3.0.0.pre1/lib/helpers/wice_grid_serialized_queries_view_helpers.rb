# encoding: UTF-8
module Wice
  module GridViewHelper

    # View helper to render the list of saved queries and the form to create a new query.
    # Parameters:
    # * <tt>:extra_parameters</tt> -  a hash of additional parameters to use when creating a new query object.
    # Read section "Adding Application Specific Logic to Saving/Restoring Queries" in README for more details.
    def saved_queries_panel(grid, opts = {})
      unless grid.kind_of? WiceGrid
        raise WiceGridArgumentError.new("saved_queries_panel: the parameter must be a WiceGrid instance.")
      end

      options = {:extra_parameters => {}}
      opts.assert_valid_keys(options.keys)
      options.merge!(opts)

      grid_name = grid.name
      id_and_name = "#{grid_name}_saved_query_name"
      base_path_to_query_controller = create_serialized_query_url(:grid_name => grid_name)

      parameters = grid.get_state_as_parameter_value_pairs

      options[:extra_parameters].each do |k, v|
        parameters << [ CGI.unescape({:extra => {k => ''}}.to_query.sub(/=$/,'')) , v.to_s ]
      end
      parameters <<  ['authenticity_token', form_authenticity_token]
      notification_messages_id = "#{grid_name}_notification_messages"
      (%! <div class="wice_grid_query_panel"><h3>#{WiceGridNlMessageProvider.get_message(:SAVED_QUERY_PANEL_TITLE)}</h3>! +
        saved_queries_list(grid_name, grid.saved_query, options[:extra_parameters]) +
        %!<div id="#{notification_messages_id}"  onmouseover="#{Wice::JsAdaptor.fade_this(notification_messages_id)}"></div>! +
        if block_given?
          view, ids = yield
          view
        else
          ''
        end +
        text_field_tag(id_and_name,  '', :size => 20, :onkeydown=>'', :id => id_and_name) +
        button_to_function(WiceGridNlMessageProvider.get_message(:SAVE_QUERY_BUTTON_LABEL),  "#{grid_name}_save_query()" ) +
        '</div>' +
        javascript_tag do
          JsAdaptor.call_to_save_query_and_key_event_initialization_for_saving_queries(
            id_and_name, grid_name, base_path_to_query_controller, parameters.to_json, ids.to_json
          ).html_safe
        end
        ).html_safe
    end

    def saved_queries_list(grid_name, saved_query = nil, extra_parameters = {})  #:nodoc:

      link_title            = WiceGridNlMessageProvider.get_message(:SAVED_QUERY_LINK_TITLE)
      deletion_confirmation = WiceGridNlMessageProvider.get_message(:SAVED_QUERY_DELETION_CONFIRMATION)
      deletion_link_title   = WiceGridNlMessageProvider.get_message(:SAVED_QUERY_DELETION_LINK_TITLE)

      query_store_model = ::Wice::get_query_store_model
      currently_loaded_query_id = saved_query ? saved_query.id : nil
      with = extra_parameters.nil? ? nil : "'"  + {:extra => extra_parameters}.to_query + "'"

      %!<ul id="#{grid_name}_query_list" class="query_list"> ! +
      query_store_model.list(grid_name, controller).collect do |sq|
        link_opts = {:class => 'query_load_link', :title => "#{link_title} #{sq.name}"}
        link_opts[:class] += ' current' if saved_query == sq
        "<li>"+
        link_to(
          image_tag(Defaults::DELETE_QUERY_ICON),
          delete_serialized_query_path(
            :grid_name => grid_name,
            :id => sq.id,
            :current => currently_loaded_query_id,
            :extra => extra_parameters
          ),
          :remote => true,
          :confirm => deletion_confirmation,
          :title => "#{deletion_link_title} #{sq.name}",
          :with => 'with'
        )  + ' &nbsp; ' +
        link_to_function(h(sq.name),
          %/ if (typeof(#{grid_name}) != "undefined") #{grid_name}.load_query(#{sq.id}) /,
          link_opts) +
        if sq.respond_to? :description
          desc = sq.description
          desc.blank? ? '' : " <i>#{desc}</i>"
        else
          ''
        end +
        '</li>'
      end.join('') + '</ul>'
    end

  end
end