require 'sidekiq/web'

Rails.application.routes.draw do
  get 'reports/call_volumes', to: 'reports#call_volumes', as: :call_volumes
  get 'reports/where_did_you_hear'

  root 'reports#call_volumes'

  mount Sidekiq::Web => '/sidekiq', constraint: AuthenticatedUser.new
end
