Rails.application.routes.draw do
  resources :reports, only: [] do
    get :call_volumes, on: :collection, as: :call_volumes
  end

  root 'reports#call_volumes'
end
