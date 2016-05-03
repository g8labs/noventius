Nuntius::Engine.routes.draw do
  resources :reports, param: :name, only: [:index, :show]
end
