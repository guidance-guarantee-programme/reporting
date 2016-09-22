require 'sidekiq/web'

Rails.application.routes.draw do
  get 'reports/call_volumes'
  get 'reports/twilio_calls'
  get 'reports/where_did_you_hear'
  get 'reports/where_did_you_hear_summary'
  get 'reports/satisfaction_summary'
  get 'reports/satisfaction'
  get 'reports/costs'

  root 'reports#call_volumes'

  resources :costs
  resources :cost_items
  resources :appointment_summaries
  resources :cita_appointment_uploads, only: [:new, :create]

  mount Sidekiq::Web => '/sidekiq', constraint: AuthenticatedUser.new
end
