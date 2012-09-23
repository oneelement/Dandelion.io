Onelement::Application.routes.draw do
  
  get "public/index"  
  get "about", to: "public#about"
  get "contact", to: "public#contact"
  get "terms", to: "public#terms"
  get "privacy", to: "public#privacy"

  resources :autocomplete do
    get 'wonderbar', :on => :collection
    get 'contacts', :on => :collection
    get 'hashtags', :on => :collection
  end
  
  resources :imports do
    get 'import_facebook', :on => :collection
    get 'import_twitter', :on => :collection
    get 'import_linkedin', :on => :collection
    get 'import_google', :on => :collection
  end

  resources :linkedin_feeds do
    get 'search', :on => :collection
    get 'profile', :on => :collection
  end

  resources :facebook_feeds do
    get 'feed', :on => :collection
    get 'search', :on => :collection
    get 'wallpost', :on => :collection
    get 'like', :on => :collection
    get 'unlike', :on => :collection
    get 'comment', :on => :collection
    get 'get_object', :on => :collection
  end

  resources :twitter_feeds do
    get 'hometimeline', :on => :collection
    get 'contacttimeline', :on => :collection
    get 'tweet', :on => :collection
    get 'search', :on => :collection
  end
  
  resources :notifications do
    get :complete_ripple, :on => :collection
  end
  
  resources :timelines do
    get :home, :on => :collection
    get :contact, :on => :collection
    get :picture_timeline, :on => :collection
  end
  
  resources :positions
  
  resources :avatars
  
  resources :user_contacts
  
  resources :public_users
  
  resources :public_contacts
  
  resources :hashtags
  
  resources :groups do
    get :multipledelete, :on => :collection
    get :multiplemerge, :on => :collection
  end

  resources :authentications

  resources :favorites

  resources :addresses
  
  resources :notes
  
  resources :phones do
    get :ripple, :on => :collection
  end
  
  resources :emails
  
  resources :urls

  resources :tasks

  resources :home
  
  resources :app, :controller => :home

  resources :question_types

  resources :answer_types

  resources :insurers

  resources :trades

  resources :policies

  resources :products do 
    resources :versions, :controller => 'product_versions'
  end

  resources :sections, :defaults => {:format => 'json'}
  resources :questions, :defaults => {:format => 'json'}

  resources :admins do
    get 'tester', :on => :collection
  end

  resources :entities

  devise_for :users, :controllers => {:registrations => 'registrations', :sessions => 'sessions'}
  
  #devise_scope :user do
  #  get "/login" => "devise/sessions#new"
  #end
  
  
  #devise_for :users, :skip => [:sessions]
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  
  
  resources :organisations

  resources :contacts do
    get :multipledelete, :on => :collection
    get :multiplemerge, :on => :collection
  end

  resources :dashboard

  resources :user do
    get :newent, :on => :collection
    get :currentuser, :on => :collection
  end

  resources :quotes

  resources :rating_blocks

  root :to => "public#index"

  match '/auth/:provider/callback' => 'authentications#create'
  
  match '/auth/failure' => 'public#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
