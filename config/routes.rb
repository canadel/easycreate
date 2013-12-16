DumboEasyCreate::Application.routes.draw do
  # get "inwx_domains/index"
  # get "inwx_domains/:id/activate_dumbo" => "inwx_domains#activate_dumbo", :as => "activate_dumbo"
  # get "inwx_domains/:id/deactivate_dumbo" => "inwx_domains#deactivate_dumbo", :as => "deactivate_dumbo"
  

  # get "inwx_credentials/index"

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  resources :pages, :only => [:index, :edit] do
    resources :documents, :only => [:index, :new, :edit]
  end

  # resources 'inwx', :only => :index do
  #   collection do
  #     get 'get_domains'
  #     get 'update_domains'
  #     get 'update_domain/:id' => "inwx#update_domain", :as => :update_domain
  #   end
  # end
  
  resources :inwx_domains, :as => 'domains' do
    get 'activate_dumbo'
    get 'deactivate_dumbo'
    get 'update_domain', :as => 'update'
    get 'choose_template'
    collection do
      get 'update_domains', :as => 'update_all'
      get 'get_domains'
    end
  end
  
  scope 'inwx' do
    resources :inwx_credentials, :as => 'credentials'
  end

  get 'update/templates'
  get 'upload' => 'upload#index'
  post 'upload/image'
  post 'upload/favicon'
  
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
  
  root :to => "landing_page#index"
end
