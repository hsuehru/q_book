Rails.application.routes.draw do
  get 'show_api_test/index'
  #post 'administrator/index'
  #get 'administrator/login' => "administrators#login"

#administrator
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

  #member
  scope :controller => "members" , :path => "members" do

    get '' => "members#index", :as => "members"
    get '/:table_number/:id/edit' => :edit, :as => "edit_member"
    post '/:table_number/:id/update' => :update, :as => "update_member"
    get '/:table_number/:id/block' => :destory, :as => "block_member"
    post '/create' => :create, :as => "create_member"
    get '/new' => :new, :as => "new_member"
    get '/login' => :login, :as => "login_member"
    get '/logout' => :logout, :as => "logout_member"
    post '/login_create' => :login_create, :as => "login_create_member"
  end


  #author
  scope :controller => "authors", :path => "authors" do
    get '' => "authors#index", :as => "authors"
    get '/login' => :login, :as => "login_author"
    post '/login_create' => :login_create, :as => "login_create_author"
    get '/logout' => :logout, :as => "logout_author"
    get '/:id/edit' => :edit, :as => "edit_author"
    patch '/:id/update' => :update, :as => "update_author"
    get '/new' => :new, :as => "new_author"
    post '/create' => :create, :as => "create_author"
    post '/:id/publish_required_create'=> :publish_required_create, 
      :as => "author_publish_required_create"
  end

  #publishs
  scope :controller => "publishs", :path => "publish" do
    get '' => :index, :as => "publishs"
    get '/login' => :login, :as => "login_publish"
    post '/login_create' => :login_create, :as => "login_create_publish"
    get '/logout' => :logout, :as => "logout_publish"
    get '/new' => :new, :as => "new_publish"
    get '/:id/edit' => :edit, :as => "edit_publish"
    patch '/:id/update' => :update, :as => "update_publish"
    post '/create' => :create, :as => "create_publish"
    delete '/:id/delete' => :delete, :as => "delete_publish"
    get '/account_index' => :account_index, :as => "accounts_index_publish"
    get '/account_new' => :account_new, :as => "account_new_publish"
    post '/account_create' => :account_create, :as => "account_create_publish"
    get '/manager_index' => :manager_index, :as => "managers_index_publish"
    get '/manager_list_edit' => :manager_list_edit,
      :as => "manager_list_edit_publish"
    post '/manager_list_add' => :manager_list_add,
      :as => "manager_list_add_publish"
    delete "/:publish_id/:id/manager_master_list_remove" => 
      :manager_master_list_remove,
      :as => "manager_master_list_remove_publish"
    delete "/:publish_id/:id/manager_sales_list_remove" => 
      :manager_sales_list_remove,
      :as => "manager_sales_list_remove_publish"
    delete "/:publish_id/:id/sales_list_remove" => 
      :sales_list_remove,
      :as => "sales_list_remove_publish"
    get "/sales_index" => :sales_index, :as => "sales_index_publish"
    get "/sales_list_edit" => :sales_list_edit,
      :as => "sales_list_edit_publish"
    post "/sales_list_add" => :sales_list_add,
      :as => "sales_list_add_publish"
    get "/author_index" => :author_index, :as => "author_index_publish"
    get "/author_list_edit" => :author_list_edit,
      :as => "author_list_edit_publish"
    post "/author_list_add" => :author_list_add,
      :as => "author_list_add_publish"
    delete "/:publish_id/:id/author_list_remove" => :author_list_remove,
      :as => "author_list_remove_publish"
    get "/author_required_list" => :author_required_list,
      :as => "author_required_list_publish"
    get "/:id/author_required_confirm" => :author_required_confirm,
      :as => "author_required_confirm_publish"
    get "/book_sales_account_type_index" => :book_sales_account_type_index,
      :as => :book_sales_account_type_index_publish 
    get "/book_sales_account_type_new" => :book_sales_account_type_new,
      :as => "book_sales_account_type_new_publish"
    post "/book_sales_account_type_create" => :book_sales_account_type_create,
      :as => "book_sales_account_type_create_publish"
    get "/:id/book_sales_account_type_edit" => :book_sales_account_type_edit,
      :as => "book_sales_account_type_edit_publish"
    patch "/:id/book_sales_account_type_update" => :book_sales_account_type_update,
      :as => "book_sales_account_type_update_publish"
    
    
    
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
