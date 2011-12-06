class InstitutionSweeper < ActionController::Caching::Sweeper
  observe Institution

  def after_save(institution)
    expire_cache_for(institution)
  end

  def after_destroy(institution)
    expire_cache_for(institution)
  end

  private

  def expire_cache_for(institution)
    # Expire institutions#index
    options = { :controller => "admins/institutions", :action => 'index' }
    expire_page(options)

    # Expire institutions#show
    options.merge! :action => 'show', :id => institution.id
    expire_page(options)
  end

end
