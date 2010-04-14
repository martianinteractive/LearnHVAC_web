Learnhvac::Application.routes.draw do |map|
  
  resources :accounts
  resources :users 
  resources :user_sessions
  resources :password_resets
  resources :client_versions, :only => [:index]
  
  match 'login'   => 'user_sessions#new', :as => 'login'
  match 'logout'  => 'user_sessions#destroy', :as => 'logout'
  match 'sign_up' => 'accounts#new', :as => 'signup'
  match 'colleges' => 'accounts#colleges'
  match 'states'  => 'accounts#states'
  match 'register/:activation_code' => 'activations#new', :as => 'register'
  match 'activate/:id' => 'activations#create', :as => 'activate'
  match 'students/sign_up' => 'students/accounts#new', :as => 'students_signup'
  match 'groups/register/(:code)' => 'memberships#create', :as => 'membership_register'
  match 'admin/master_scenarios/tagged/:tag' => "admin/master_scenarios#tag", :as => 'master_scenarios_tag'
  
  resources :groups do
    resources :students, :only => [:index, :show]
    resources :memberships, :only => [:destroy]
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
  
  # Manager Routes.
  namespace :managers do
    resources :instructors
    
    resources :groups do
      resources :memberships
    end
    
    resources :scenarios do
      resources :variables, :controller => "scenario_variables"
      
      collection do
        get :list
      end
    end
    
  end
  
  # Admin Routes.
  namespace :admin do
    resources :institutions
    resources :tags
    resources :client_versions
    
    resources :master_scenarios do
      resources :system_variables
      
      resources :revisions do
        resources :variables, :controller => "system_variable_versions"
      end  
      
      member do
        post :clone
      end
    end
    
    resources :groups do
      resources :students, :only => [:index]
    end
    
    resources :users do
      collection do
        post :search
      end
    end
    
    resources :scenarios do
      resources :scenario_variables
      
      collection do
        get :list
      end
    end
    
  end

  root :to => 'scenarios#index'
end
