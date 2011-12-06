class ScenarioVariableSweeper < ActionController::Caching::Sweeper

  observe ScenarioVariable

  def after_save(variable)
    expire_cache_for(variable)
  end

  def after_destroy(variable)
    expire_cache_for(variable)
  end

  private

  def expire_cache_for(variable)
    namespaces = User::ROLES.keys - [:guest, :student]
    namespaces.each do |namespace|
      namespace = namespace.to_s.pluralize
      # Expire variables#index
      options = {
        :controller => "#{namespace}/variables",
        :action     => 'index'
      }
      expire_page(options)

      # Expire variables#show
      options.merge!(
        :action       => 'show',
        :scenario_id  => variable.scenario.id,
        :id           => variable.id
      )
      expire_page(options)
    end
  end

end
