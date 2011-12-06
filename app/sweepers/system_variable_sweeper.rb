class SystemVariableSweeper < ActionController::Caching::Sweeper
  observe SystemVariable

  def after_save(variable)
    expire_cache_for(variable)
  end

  def after_destroy(variable)
    expire_cache_for(variable)
  end

  private

  def expire_cache_for(variable)
    # Expire system_variables#index
    options = { :controller => 'admins/system_variables', :action => 'index' }
    expire_page(options)

    # Expire system_variables#show
    options.merge!(
      :action             => 'show',
      :master_scenario_id => variable.master_scenario.id,
      :id                 => variable.id
    )
    expire_page(options)
  end

end
