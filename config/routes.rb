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

      # confirmations
      get 'confirm_email', to: 'confirmations#confirm_email'
      put 'resend_confirm_email', to: 'confirmations#resend_confirm_email'

      # reset_password
      post 'forgot_password_email', to: 'passwords#create_reset_password_email'
      get 'verify_reset_password_email', to: 'passwords#verify_reset_email_token'
      put 'reset_password', to: 'passwords#reset_password'
    end
  end
end
