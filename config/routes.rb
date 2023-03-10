Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  namespace :api, defaults: { format: :json } do
    namespace :v1, defaults: { format: :json } do

      resources :accounts, except: [:destroy] do
        patch :close, on: :member
        post :deposits, on: :collection
        post :transfers, on: :member
        get :balances, on: :member
        get :extracts, on: :member
        patch :withdraws, on: :member
      end

    end
  end
end
