Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :auth do
      # registrations
      post 'sign_up', to: 'registrations#create'
      delete 'destroy', to: 'registrations#destroy'

      # sessions
      get 'validate_token', to: 'sessions#validate_token'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'

      # confirmations
      get 'confirm_email', to: 'confirmations#confirm_email'
      post 'send_confirmation_email', to: 'confirmations#send_confirmation_email'

      # reset_password
      post 'forgot_password', to: 'passwords#forgot_password'
      get 'verify_reset_password_token', to: 'passwords#verify_reset_password_token'
      put 'reset_password', to: 'passwords#reset_password'
    end
  end
end
