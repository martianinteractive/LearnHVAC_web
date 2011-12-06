class GroupSweeper < ActionController::Caching::Sweeper
  observe Group

  def after_save(group)
    expire_cache_for(group)
    expire_group_scenarios(group)
  end

  def after_destroy(group)
    expire_cache_for(group)
    expire_group_scenarios(group)
  end

  private

  def expire_cache_for(group)
    namespaces = User::ROLES.keys - [:guest]
    namespaces.each do |namespace|
      namespace = namespace.to_s.pluralize
      # Expire 'index'
      options = {
        :controller => "#{namespace}/groups",
        :action     => 'index'
      }
      expire_page(options)

      # Expire 'show'
      options.merge! :action => 'show', :id => group.id
      expire_page(options)
    end
  end

  def expire_group_scenarios(group)
    namespaces = User::ROLES.keys - [:guest]
    namespaces.each do |namespace|
      namespace = namespace.to_s.pluralize
      group.scenarios.each do |scenario|
        # Expire scenarios#show
        options = {
          :controller => "#{namespace}/scenarios",
          :action     => 'show',
          :id         => scenario.id
        }
        expire_page(options)

        # Expire access#index
        options = {
          :controller   => "#{namespace}/access",
          :action       => 'index',
          :scenario_id  => scenario.id
        }
        expire_page(options)

        # Expire variables#index
        options.merge! :controller => "#{namespace}/variables"
        expire_page(options)
      end
    end
  end

end
