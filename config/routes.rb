Ada::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'user_sessions' }
  
  match 'staff/home', :to => 'staff/home#dashboard', :as => "user_root"
  
  devise_scope :user do 
    get "login", :to => "user_sessions#new"    
    get "logout", :to => "user_sessions#destroy"
  end
  
  namespace :staff do
    resources :activity_logs, :only => :index
    resources :ddi_mappings
    resources :users, :only => [:index, :show]

    get 'site_resources', :to => "site_resources#index" #temporary 
    get 'hccda', :to => "hccda#index" #temporary 
    get 'adapt', :to => "adapt#index" #temporary 
    get 'usage-auditing', :to => "usage_auditing#index" #temporary 
    
    post 'archives/pages/sluggerize_path'
    post 'archives/pages/preview'
    post 'archives/update_menu_order'

    resources :archives, :only => :show do
      resources :pages, :except => [:index, :show], :controller => "archives/pages" do
        collection do
          get 'browse'
        end

        member do
          post 'publish'
        end
      end

      resources :menu_items, :except => [:index, :show], :controller => "archives/menu_items" do
        member do
          post 'publish'
        end

      end
    end

    resources :news, :except => [:show] do
      post 'preview'

      member do
        post 'publish'
      end
    end

    resources :documents, :images do
      collection do
        # Generate /staff/documents/browse -> browse_staff_documents, same for images
        get 'browse'
      end
    end
    
    get 'resources', :to => 'resources#index'
  end

  resources :users do
    resources :searches, :controller => 'users/searches', :except => [:edit, :new, :update]
  end

  resources :searches, :only => [:show, :create]
  get '/search', :to => "searches#transient", :path => "search", :as => 'transient_search' #path is necessary, see http://stackoverflow.com/questions/4134606/routing-trouble-on-rails-3-related-to-singular-plural

  get 'browse_archive_catalog', :to => "archive_catalogs#browse"
  get '/ada/browse', :to => "archive_catalogs#show", :defaults => {:id => nil}
  get '/browse', :to => "archive_catalogs#show", :defaults => {:id => nil}
  
  inkling_match(:archive_studies)
  inkling_match(:archive_catalogs)
  inkling_match(:pages)
  inkling_match(:archive_news)
  inkling_match(:documents)
  inkling_match(:images)
  inkling_match("inkling/feeds")

  match 'ADAData/*rest' => 'ada_data#show'

  root :to => "pages#show_by_slug", :as => :root, :defaults => {:slug => "/ada/home"}

  #because Rails 3.0.x has broken rescue_from, see http://techoctave.com/c7/posts/36-rails-3-0-rescue-from-routing-error-solution
  match '*miss', :to => 'errors#routing'
end

