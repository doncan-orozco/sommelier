Rails.application.routes.draw do
  devise_for :admin_users, path: "admin", path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "menu#index"

  # Public routes
  resources :menu, only: [ :index ]
  resources :orders, only: [ :create, :show, :new ] do
    member do
      patch :update_status
    end
  end

  # Admin routes
  namespace :admin do
    root "dashboard#index"
    resources :categories
    resources :menu_items do
      member do
        patch :toggle_availability
      end
    end
    resources :orders, only: [ :index, :show, :update ] do
      member do
        patch :update_status
      end
    end
    get "kitchen", to: "kitchen#index"
    get "stats", to: "dashboard#stats"
  end

  # API routes for real-time updates
  namespace :api do
    namespace :v1 do
      resources :orders, only: [ :index, :show ]
      get "kitchen/orders", to: "kitchen#orders"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
