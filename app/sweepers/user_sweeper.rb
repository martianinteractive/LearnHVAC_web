class UserSweeper < ActionController::Caching::Sweeper

  observe User

  def after_save(user)
    unless user.last_request_changed?
      expire_user_actions(user)
      expire_user_scenarios(user)
    end
  end

  def after_destroy(user)
    unless user.last_request_changed?
      expire_user_actions(user)
      expire_user_scenarios(user)
    end
  end

  private

  def expire_user_actions(user)
    expire_page(:controller => 'users', :action => 'update')
    expire_page(:controller => 'admins/users', :action => 'index')
    expire_page(:controller => 'admins/users', :action => 'show', :id => user.id)
  end

  def expire_user_scenarios(user)
    roles     = User::ROLES.keys - [:guest, :student]
    scenarios = user.all_scenarios
    if roles.include? user.role
      namespace = user.role.to_s.pluralize
      scenarios.each do |scenario|
        options = {
          :controller => "#{namespace}/scenarios",
          :action     => 'index'
        }
        # Expire scenarios 'index' view.
        expire_page(options)

        # Expire scenario 'show' view.
        options[:action]  = 'show'
        options[:id]      = scenario.id
        expire_page(options)
      end
    end
  end

end
