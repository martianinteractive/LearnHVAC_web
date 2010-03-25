Learnhvac::Application.routes.draw do |map|
  
  resources :accounts
  resources :users 
  resources :user_sessions
  map.resources :password_resets
  
  match 'login'   => 'user_sessions#new', :as => 'login'
  match 'logout'  => 'user_sessions#destroy', :as => 'logout'
  match 'sign_up' => 'accounts#new', :as => 'sign_up'
  match 'register/:activation_code' => 'activations#new', :as => 'register'
  match 'activate/:id' => 'activations#create', :as => 'activate'
  match 'students/sign_up' => 'students/accounts#new', :as => 'students_signup'
  match 'groups/register/(:code)' => 'memberships#create', :as => 'membership_register'
  
  resources :groups do
    resources :students, :only => [:index]
  end
  
  resources :scenarios do
    resources :scenario_variables
  end

  match 'admin/dashboard' => 'admin/dashboard#show', :as => 'admin_dashboard'
  
  # Student Routes.
  namespace :students do
    resources :accounts
    resources :groups
  end
  
  # Admin Routes.
  namespace :admin do
    resources :institutions
    
    resources :master_scenarios do
      resources :system_variables
    end
    
    resources :groups do
      resources :students, :only => [:index]
    end
    
    resources :users do
      resources :instructor_variables
    end
    
    resources :scenarios do
      resources :scenario_variables
    end
  end

  root :to => 'scenarios#index'
end
