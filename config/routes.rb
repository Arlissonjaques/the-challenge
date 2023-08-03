Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      # registrations
      post 'sign_up', to: 'registrations#create'
      delete 'destroy', to: 'registrations#destroy'
    end
  end
end
