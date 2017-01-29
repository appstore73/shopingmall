Rails.application.routes.draw do
  resources :products, only: [:index]
  resource :cart, only: [:show] do
    member do
      get :checkout
      post :payment
      get :invoice
    end
  end
  resources :order_items, only: [:create, :update, :destroy]
  root to: "products#index"
end
