Learnhvac::Application.routes.draw do |map|
  resources :system_variables
  resources :accounts
  
  resources :groups
  resources :users 
 
  resources :user_sessions
  map.resources :password_resets
  
  match 'login'   => 'user_sessions#new', :as => "login"
  match 'logout'  => 'user_sessions#destroy', :as => "logout"
  match 'sign_up' => 'accounts#new', :as => "sign_up"
  match 'register/:activation_code' => 'activations#new', :as => "register"
  match 'activate/:id' => 'activations#create', :as => "activate"
  
  resources :scenarios do
    resources :scenario_variables
  end

  match 'admin/dashboard' => 'admin/dashboard#show', :as => "admin_dashboard"
  
  namespace :students do
    resources :groups
  end
  
  namespace :admin do
    resources :system_variables
    resources :institutions
    
    resources :users do
      resources :instructor_variables
    end
    
    resources :scenarios do
      resources :scenario_variables
    end
  end

  root :to => "user_sessions#new"
end
