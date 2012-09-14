FreeFoodUmn::Application.routes.draw do



  get '/admins/sign_up' => redirect('/')
  get '/admins/password/new' => redirect('/')

  resources :events

  devise_for :admins
  match '/admin' => "admin#index"

  devise_for :organizations
  match '/create_event' => 'events#create_event_from_session_stored_params'

  root :to => redirect('/view_by_week')
  match '/join_us' => "pages#join_us"

  match '/view_by_month' => 'date_view#view_by_month'
  match '/month/:month/year/:year' => "date_view#view_by_month"
  match '/view_by_week' => "date_view#view_by_week", :as => 'root'
  match '/view_by_week/:year/:month/:day' => "date_view#view_by_week"

  match '/mobile' => "date_view#mobile"
  match '/mobile/previous/:n' => "date_view#mobile"
  match '/mobile/next/n' => "date_view#mobile"

  match '/admin_approve_event/:id' => "admin#admin_approve_event"
  match '/admin_approve_organization/:id' => "admin#admin_approve_organization"

  #hacks to get around fact that delete requests are not working for some reason
  devise_scope :organization do
    match '/organizations/signout' => 'devise/sessions#destroy'
  end
  devise_scope :admin do
    match '/admins/signout' => 'devise/sessions#destroy'
  end
  match '/delete/event/:id' => "events#destroy"

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
