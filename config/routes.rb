Rails.application.routes.draw do
  get 'show_api_test/index'
  #post 'administrator/index'
  #get 'administrator/login' => "administrators#login"

  get 'administrators/login'
  post 'administrators/login_create'
  get 'administrators/logout'
  get 'administrators/index'
  get 'administrators/administrator_type_new'
  get 'administrators/administrator_type_index'
  get 'administrators/administrator_type_destory'
  #post 'administrators/administrator_type_update'



  resource :administrators do
    collection do
      post :block_account
      post :administrator_type_create
      post :administrator_type_update
      patch :administrator_type_update
      delete :administrator_type_destory
    end
    member do
      post :logout
      #post :administrator_type_update
      get :block_account
      get :administrator_type_edit
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
