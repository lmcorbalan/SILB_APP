SILBApp::Application.routes.draw do

  get "errors/show"

  get "customers/index"

  root to: 'static_pages#home'

  resources :users,            only: [:new, :create, :edit, :update]
  resources :sessions,         only: [:new, :create, :destroy]
  resources :password_resets
  resources :user_activations, only: [:edit]

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/contact', to: 'static_pages#contact'

  resources :products, only: [:index, :show]
  match '/catalog', to: 'products#index'

  resources :orders, only: [:index]
  match '/shopping_cart', to: 'orders#show'
  resources :line_items,  only: [:create, :destroy, :update]

  resources :shipping_addresses,  only: [:new, :create]
  match '/checkout', to: 'shipping_addresses#new'

  resources :shipping_costs,  only: [:index]

  resources :order_payments, only: [:new, :create]
  match '/express',       to: 'order_payments#express'
  match '/paypal_cancel', to: 'order_payments#paypal_cancel'

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'

    resources :users,                  only: [:index, :new, :create, :edit, :update, :destroy]

    resources :regions,                only: [:index, :new, :create, :edit, :update]
    resources :region_states,          only: [:update]

    resources :cities,                 only: [:index, :new, :create, :edit, :update]
    resources :city_states,            only: [:update]

    resources :shipping_methods,       only: [:index, :new, :create, :edit, :update]
    resources :shipping_method_states, only: [:update]

    resources :shipping_costs,         only: [:index, :new, :create, :edit, :update]
    resources :shipping_cost_states,   only: [:update]

    resources :categories,             only: [:index, :new, :create, :edit, :update, :destroy]

    resources :brands,                 only: [:index, :new, :create, :edit, :update]
    resources :brand_states,           only: [:update]

    resources :products,               only: [:index, :show, :new, :create, :edit, :update]
    resources :product_states,         only: [:update]

    resources :pictures,               only: [:index, :create, :destroy]

    resources :orders,                 only: [:index, :show, :update]

    resources :customers,              only: [:index]

    # get '/sales_report', to: 'reports#sales_report'
    match '/sales_report', to: 'reports#sales_report', via: [:post, :get]

  end

  match 'errors/:status', to: 'errors#show', constraints: {status: /\d{3}/} #,  via: :all
  match '/:status', to: 'errors#show', constraints: {status: /\d{3}/} #,  via: :all

end
