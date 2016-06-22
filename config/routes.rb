require 'sidekiq/web'

Rails.application.routes.draw do
  get 'reports/call_volumes', to: 'reports#call_volumes', as: :call_volumes
  get 'reports/where_did_you_hear'
  get 'reports/where_did_you_hear_summary'
  get 'reports/satisfaction_summary'
  get 'reports/satisfaction'

  root 'reports#call_volumes'

  resources :appointment_summaries

  mount Sidekiq::Web => '/sidekiq', constraint: AuthenticatedUser.new
end
