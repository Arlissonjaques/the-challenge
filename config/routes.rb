Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      # registrations
      post 'sign_up', to: 'registrations#create'
      delete 'destroy', to: 'registrations#destroy'

      # sessions
      get 'validate_token', to: 'sessions#validate_token'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
    end
  end
end
