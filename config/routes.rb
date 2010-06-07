Learnhvac::Application.routes.draw do |map|
  
  resources :accounts
  resources :user_sessions
  resources :password_resets
  resources :client_versions, :only => [:index]
  resources :users, :only => [:update, :edit]
    
  match 'login'   => 'user_sessions#new', :as => 'login'
  match 'logout'  => 'user_sessions#destroy', :as => 'logout'
  match 'signup' => 'accounts#new', :as => 'signup'
  match 'colleges' => 'accounts#colleges'
  match 'states'  => 'accounts#states'
  match 'register/:activation_code' => 'activations#new', :as => 'register'
  match 'activate/:id' => 'activations#create', :as => 'activate'
  match 'students/signup' => 'students/accounts#new', :as => 'students_signup'
  match 'guests/signup' => 'guests/accounts#new', :as => 'guests_signup'
  match 'groups/register/(:code)' => 'memberships#create', :as => 'membership_register'
  match 'admin/master_scenarios/tagged/:tag' => "admin/master_scenarios#tag", :as => 'master_scenarios_tag'
  match 'admin/dashboard' => 'admin/dashboard#show', :as => 'admins_dashboard'
  match 'directory' => 'directory/institutions#index', :as => 'directory'
  match 'reset_password' => 'password_resets#new', :as => 'reset_password'
  match 'profile' => 'users#show', :as => 'profile'
 
 ## API ROUTES
 namespace :api do
   resources :scenarios
   match 'users/user.:format' => 'api/users#show'
 end
 
  ## Directory Routes.
  namespace :directory do
    resources :institutions, :only => [:index, :show] do
      resources :scenarios, :only => [:show] do
        resources :variables, :only => [:index, :show]
      end
    end
  end
 
  ## Instructors Routes 
  namespace :instructors do
    resources :students, :only => [:show]
    resource :dashboard, :only => [:show]
    resources :client_versions
    resources :scenarios do
      resources :variables
      member do
        get :observers
      end
    end
    resources :groups do
      resources :students, :only => [:index, :show]
      resources :memberships, :only => [:destroy]
    end
  end
  
  ## Guests Routes.
  namespace :guests do
    resources :accounts
    resource  :dashboard, :controller => "dashboard"
  end
  
  ## Student Routes.
  namespace :students do
    resources :accounts
    resources :groups
  end
  
  ## Manager Routes.
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
      member do
        get :observers
      end
    end
  end
  
  ### Admin Routes.
  namespace :admins do
    resources :institutions
    resources :tags
    resources :client_versions
    resources :settings, :only => [:index]
    
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
    
    scope ":role" do
      resources :users, :requirements => { :role => /[a-z]/ }  do 
        collection do
          post :search
          get :list
        end
      end
    end
    
    resources :scenarios do
      resources :scenario_variables
      collection do
        get :list
      end
      member do
        get :observers
      end
    end
    
    resources :colleges do
      collection do
        post :search
      end
    end
  end

  root :to => 'dashboard#index'
end
