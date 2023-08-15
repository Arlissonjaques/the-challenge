module ResponseConcern
  extend ActiveSupport::Concern

  def success_response(http_code, message_key = nil)
    @message = I18n.t("success.controllers.auth.#{message_key}") if message_key.present?
    render status: http_code, template: 'auth/success_response' 
  end

  def error_response(http_error, error_key = nil)
    @error_message = I18n.t("errors.controllers.auth.#{error_key}") if error_key.present?
    render status: http_error, template: 'auth/error_response'
  end 
end
