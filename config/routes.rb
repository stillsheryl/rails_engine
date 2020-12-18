Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      scope :merchants, module: :merchants do
        resources :search, :path => "/find_all", only: [:index]
      end

      get '/merchants/find', to: 'merchants/search#show'

      scope :items, module: :items do
        resources :search, :path => "/find_all", only: [:index]
      end

      get '/items/find', to: 'items/search#show'

      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      get '/merchants/:id/revenue', to: 'merchants#revenue'
      get '/merchants/most_items', to: 'merchants#most_items_sold'

      resources :merchants, only: [:index, :show, :create, :update, :destroy] do
        scope module: :merchants do
          resources :items, only: [:index]
        end

      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        scope module: :items do
          resources :merchants, only: [:index]
        end
      end
    end
  end
end
