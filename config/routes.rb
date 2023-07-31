Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      post 'sign_up', to: 'registrations#create'
    end
  end
end
