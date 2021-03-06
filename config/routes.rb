Chooseit::Application.routes.draw do

  delete 'services/:id' => 'services#destroy', :as => :services_destroy

  post 'temp_files' => 'temp_files#create', :as => :temp_files_create
  
  get 'vote'             => 'votes#random', :as => :votes_random
  put 'vote/:id/:choice' => 'votes#vote', :as   => :votes_vote

  get 'tots'        => 'tots#index', :as   => :tots_index
  get 'tots/new'    => 'tots#new', :as     => :tots_new
  get 'tots/:id'    => 'tots#show', :as    => :tots_show
  post 'tots'       => 'tots#create', :as  => :tots_create
  delete 'tots/:id' => 'tots#destroy', :as => :tots_destroy

  # resources :visitor_messages
  get 'contact' => 'VisitorMessages#new', :as => :visitor_messages_new
  post 'contact' => 'VisitorMessages#create', :as => :visitor_messages_create
  get 'contact/thanks' => 'VisitorMessages#thanks', :as => :visitor_messages_thanks
  
  devise_scope :user do
    get 'sign_in', :to       => 'users/sessions#new', :as      => :new_user_session
    get 'sign_out', :to      => 'users/sessions#destroy', :as  => :destroy_user_session
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

  get "welcome/index"
  get 'invite' => 'welcome#invite', :as => :welcome_invite

  root :to => "welcome#index"
  
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
  # match ':controller(/:action(/:id))(.:format)'
end
