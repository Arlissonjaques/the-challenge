module ErrorsResponseConcern
  extend ActiveSupport::Concern

  def unprocessable_entity(error_message)
    @error_message = error_message

    render status: :unprocessable_entity, template: 'auth/auth_failure'
  end

  def unauthorized
    render status: :unauthorized, json: {
      errors: [
        I18n.t('errors.controllers.auth.unauthenticated')
      ]
    }
  end
end
