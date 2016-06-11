Nuntius::Engine.routes.draw do
  resources :reports, param: :name, only: [:index, :show] do
    member do
      get :execute
    end
  end
end
