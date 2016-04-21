Rails.application.routes.draw do
  get 'reports/call_volumes', to: 'reports#call_volumes', as: :call_volumes

  root 'reports#call_volumes'
end
