Nuntius::Engine.routes.draw do
  resources :reports, param: :name, only: [:index, :show] do
    get :nested, on: :member
  end
end
