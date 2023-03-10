Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1, defaults: { format: :json } do

      resources :accounts, except: [:destroy] do
        patch :close_accounts, on: :member
        post :deposits, on: :member
        post :transfers, on: :member
        get :balances, on: :member
      end

    end
  end
end
