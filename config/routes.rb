Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1, defaults: { format: :json } do

      resources :accounts, except: [:destroy] do
        patch :close_accounts, on: :member
        post :deposits, on: :collection
      end

    end
  end
end
