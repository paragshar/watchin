Social::Application.routes.draw do
   scope "/api" do
      get '/messages/public/:id', :controller=>'messages', :action => 'public', :as => 'messages_public'
      get '/messages/private/:id', :controller=>'messages', :action => 'private', :as => 'messages_private'
      get '/channels/get_programmes/:id', :controller=>'channels', :action => 'get_programmes'
      get '/messages/friends/', :controller=>'messages', :action => 'friends'
      get '/messages/friends/:id', :controller=>'messages', :action => 'friends_programme', :as => 'friends_programme' 
      get '/channels/private', :controller=>'channels', :action => 'private'
      get '/channels/public', :controller=>'channels', :action => 'public'
      get '/users/search/', :controller=>'users', :action => 'search'
      
  end
  #devise_for :users
  devise_for :users, controllers: { sessions: "users/sessions", registrations:  "users/registrations" }, :path => "api/users"
  scope "/api" do
    resources :users, :home, :friendships, :friendship_requests, :channels, :programmes, :messages
  end  
 

  # resources :users, :path => "/api/users"
  # resources :friends, :path => "/api/friends"


  # get "users/index"
# #   
  get "users/:id" => 'users#show'
  
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
  root :to => "home#index"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
