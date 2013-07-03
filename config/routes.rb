SILBApp::Application.routes.draw do

  root to: 'static_pages#home'

  resources :users,            only: [:new, :create, :edit, :update]
  resources :sessions,         only: [:new, :create, :destroy]
  resources :password_resets
  resources :user_activations, only: [:edit]

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/contact', to: 'static_pages#contact'

  resources :products, :as => "catalogs", only: [:index, :show]

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'

    resources :users,            only: [:index, :new, :create, :edit, :update, :destroy]

    resources :regions,          only: [:index, :new, :create, :edit, :update]
    resources :region_states,    only: [:update]

    resources :cities,           only: [:index, :new, :create, :edit, :update]
    resources :city_states,      only: [:update]

    resources :shipping_methods,       only: [:index, :new, :create, :edit, :update]
    resources :shipping_method_states, only: [:update]

    resources :shipping_costs,         only: [:index, :new, :create, :edit, :update]
    resources :shipping_cost_states,   only: [:update]

    resources :categories,       only: [:index, :new, :create, :edit, :update, :destroy]

    resources :brands,        only: [:index, :new, :create, :edit, :update]
    resources :brand_states,  only: [:update]

    resources :products,        only: [:index, :show, :new, :create, :edit, :update]
    resources :product_states,  only: [:update]

    resources :pictures,        only: [:index, :create, :destroy]

  end

end
