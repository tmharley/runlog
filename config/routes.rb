Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static_pages#home'
  resources :runs do
    collection do
      get 'search'
    end
  end
  resources :shoes
  resources :weather_types, except: [:show]
  get 'training' => 'static_pages#training'
end
