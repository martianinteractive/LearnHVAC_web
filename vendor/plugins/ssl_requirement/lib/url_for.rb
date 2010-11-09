require 'action_dispatch/routing/route_set'

module ActionDispatch
  module Routing
    class RouteSet

      # Add a secure option to the rewrite method.
      def url_for_with_secure_option(options = {})
        secure = options.delete(:secure)

        # if secure && ssl check is not disabled, convert to full url with https
        if !secure.nil? && !SslRequirement.disable_ssl_check?
          if secure == true || secure == 1 || secure.to_s.downcase == "true"
            options.merge!({
              :only_path => false,
              :protocol => 'https'
            })

            # if we've been told to use different host for ssl, use it
            unless SslRequirement.ssl_host.nil?
              options.merge! :host => SslRequirement.ssl_host
            end

            # make it non-ssl and use specified options
          else
            options.merge!({
              :protocol => 'http'
            })
          end
        end

        url_for_without_secure_option(options)
      end

      # if full URL is requested for http and we've been told to use a
      # non-ssl host override, then use it
      def url_for_with_non_ssl_host(options)
        if !options[:only_path] && !SslRequirement.non_ssl_host.nil?
          if !(/^https/ =~ (options[:protocol] || @request.protocol))
            options.merge! :host => SslRequirement.non_ssl_host
          end
        end
        url_for_without_non_ssl_host(options)
      end

      # want with_secure_option to get run first (so chain it last)
      alias_method_chain :url_for, :non_ssl_host
      alias_method_chain :url_for, :secure_option
    end
  end
end
