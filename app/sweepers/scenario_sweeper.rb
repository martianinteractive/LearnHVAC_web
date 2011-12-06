class ScenarioSweeper < ActionController::Caching::Sweeper

  observe Scenario

  def after_save(scenario)
    expire_cache_for(scenario)
  end

  def after_destroy(scenario)
    expire_cache_for(scenario)
  end

  private

  def expire_cache_for(scenario)
    roles = User::ROLES.keys - [:guest, :student]
    roles.each do |role|
      namespace = role.to_s.pluralize

      # Expire 'index'
      options   = {
        :controller => "#{namespace}/scenarios",
        :action     => 'index'
      }
      expire_page(options)

      # Expire 'show'
      options.merge! :action => 'show', :id => scenario.id
      expire_page(options)
    end
  end

end
