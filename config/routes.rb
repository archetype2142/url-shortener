Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :urls, only: [:create]
  get '/:short_url', to: 'urls#show'
  
  root "urls#index"
end
