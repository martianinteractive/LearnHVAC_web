class MembershipSweeper < ActionController::Caching::Sweeper

  observe Membership

  def after_save(membership)
    expire_cache_for(membership)
  end

  def after_destroy(membership)
    expire_cache_for(membership)
  end

  private

  def expire_cache_for(membership)
    namespaces = User::ROLES.keys - [:guest, :student]
    namespaces.each do |namespace|
      namespace = namespace.to_s.pluralize
      options   = {
        :controller => "#{namespace}/access",
        :action     => 'index'
      }
      expire_page(options)
    end
  end

end
