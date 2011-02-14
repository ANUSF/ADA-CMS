Ada::Application.routes.draw do
  # match 'staff/home', :to => 'inkling/home#dashboard', :as => "user_root"  
  match 'staff/home', :to => 'staff/home#dashboard', :as => "user_root"  
  
  devise_scope :inkling_user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end
  
  
  namespace :staff do
    resources :activity_logs, :only => :index

    resources :pages, :except => :index
    post 'pages/sluggerize_path'
    post 'pages/preview'
    
    resources :archives

    # post '/archives/update_page_order'
    # # resource :archives, :only => :show
    # match '/archives/:slug' => "archives#show", :as => "archives", :defaults => {:slug => "ada"}
    # # match '/archives/' => "archives#show", :as => "archive", :defaults => {:slug => "/ada"}
  end
  
  match '/*path' => "archive_studies#show", :as => :archive_study, :constraints => Inkling::Routing::TypeConstraint.new("ArchiveStudy")
  match '/*path' => "pages#show", :as => :page, :constraints => Inkling::Routing::TypeConstraint.new("Page")
  root :to => "pages#show_by_slug", :as => :root, :defaults => {:slug => "/ada/home"}
end

