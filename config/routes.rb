Learnhvac::Application.routes.draw do |map|
  
  Jammit::Routes.draw(map)
  resources :accounts, :only => [:create]
  resources :user_sessions
  resources :password_resets
  resources :client_versions, :only => [:index]
  resources :users, :only => [:update]
    
  match 'login'   => 'user_sessions#new', :as => 'login'
  match 'logout'  => 'user_sessions#destroy', :as => 'logout'
  match 'signup' => 'accounts#new', :as => 'signup'
  match 'colleges' => 'accounts#colleges'
  match 'states'  => 'accounts#states'
  match 'register/:activation_code' => 'activations#new', :as => 'register'
  match 'activate/:id' => 'activations#create', :as => 'activate'
  match 'students/signup' => 'students/accounts#new', :as => 'students_signup'
  match 'classes/register/(:code)' => 'memberships#create', :as => 'membership_register'
  match 'admins/master_scenarios/tagged/:tag' => "admins/master_scenarios#tag", :as => 'master_scenarios_tag'
  match 'admins/dashboard' => 'admins/dashboard#show', :as => 'admins_dashboard'
  match 'directory' => 'directory/dashboard#index', :as => 'directory'
  match 'reset_password' => 'password_resets#new', :as => 'reset_password'
  match 'profile' => 'users#show', :as => 'profile'
  match 'profile/edit' => 'users#edit', :as => 'edit_profile'
 
 ## API ROUTES
 namespace :api do
   resources :scenarios
   match 'users/user.:format' => 'users#show'
 end
 
  ## Directory Routes.
  namespace :directory do
    resources :people, :only => [:index, :show]
    
    resources :institutions, :only => [:index, :show] do
      resources :scenarios, :only => [:show] do
        resources :variables, :only => [:index, :show]
      end
    end
  end
 
  ## Instructors Routes 
  namespace :instructors do
    resources :accounts, :only => [:create]
    resources :students, :only => [:show]
    resource :dashboard, :only => [:show]
    resources :client_versions
    
    resources :scenarios do
      resources :alerts, :only => [:index, :show, :update]
      resources :accesses, :only => [:index, :destroy], :controller => :access
      
      resources :variables do
        collection do
          put :update_status
          delete :drop
        end
      end
    end
    
    resources :classes, :controller => :groups do
      resources :students, :only => [:index, :show]
      resources :memberships, :only => [:destroy]
      resources :emails
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
    resources :classes, :controller => :groups
  end
  
  ## Manager Routes.
  namespace :managers do
    resources :instructors
    resource :dashboard, :only => [:show]
    
    resources :classes, :controller => :groups do
      resources :memberships, :only => [:destroy]
    end
    
    resources :scenarios do
      resources :variables, :controller => "scenario_variables"
      resources :accesses, :only => [:index, :create, :destroy], :controller => :access
      
      collection do
        get :list
      end
    end
  end
  
  ### Admin Routes.
  namespace :admins do
    resources :institutions
    resources :tags
    resources :settings, :only => [:index]
    namespace :settings do
      resources :client_versions
      resources :educational_entities do
        collection do
          post :search
        end
      end
    end
    
    resources :master_scenarios do
      resource :version_note, :only => [:new, :create]
      
      resources :system_variables do
        collection do
          get :yaml_dump
          put :update_status
          delete :drop
        end
      end
      resources :revisions do
        resources :variables, :controller => "system_variable_versions"
      end  
      member do
        post :clone
      end
    end
    
    resources :classes, :controller => :groups do
      resources :memberships, :only => [:destroy]
    end
    
    scope ":role" do
      resources :users, :requirements => { :role => /[a-z]/ }  do 
        collection do
          post :search
          post :filter
          get :list
        end
      end
    end
    
    resources :scenarios do
      resources :accesses, :only => [:index, :create, :destroy], :controller => :access
      
      resources :variables do
        collection do
          put :update_status
          delete :drop
        end
      end
      
      collection do
        get :list
      end
    end  
  end

  root :to => 'dashboard#index'
end
