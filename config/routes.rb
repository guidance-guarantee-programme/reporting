require 'sidekiq/web'

Rails.application.routes.draw do
  constraints AuthenticatedUser.new do
    mount Sidekiq::Web, at: '/sidekiq'
    mount Blazer::Engine, at: 'blazer'
  end

  get 'reports/call_volumes'
  get 'reports/tp_calls'
  get 'reports/twilio_calls'
  get 'reports/twilio_numbers/new' => 'reports#twilio_number_new'
  post 'reports/twilio_numbers' => 'reports#twilio_number_create'
  get 'reports/where_did_you_hear'
  get 'reports/where_did_you_hear_summary'
  get 'reports/satisfaction_summary'
  get 'reports/satisfaction'
  get 'reports/costs'
  get 'reports/cost_breakdowns'
  get 'reports/cost_breakdowns_raw'

  root 'reports#call_volumes'

  resources :searches, only: :index

  resources :costs
  resources :cost_items
  resources :appointment_summaries
  resources :cita_appointment_uploads, only: [:new, :create]
end
