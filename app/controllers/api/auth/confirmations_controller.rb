class Api::Auth::ConfirmationsController < ApplicationController
  include SessionConcern
  include ResponseConcern

  skip_before_action :authenticate_user

  def confirm_email
    return error_response(:unprocessable_entity, :insufficient_params) if params[:token].blank?

    verification = UserVerification.search(:pending, :confirm_email, params[:token])

    return error_response(:unauthorized, :invalid_token) if verification.nil?

    if token_not_expired?(verification)
      verification.user.confirm
      verification.update(status: :done)
      # TODO: redirect to the page that says the email is confirmed successfully or can be redirected to the app
      # redirect_to "#{ENV['REDIRECT_CONFIRM_EMAIL']}?token=#{@token}"
    else
      error_response(:unauthorized, :expired_token)
    end
  end

  def send_confirmation_email
    return error_response(:unprocessable_entity, :insufficient_params) if params[:email].blank?

    @user = User.find_by(email: params[:email])

    return error_response(:unprocessable_entity, :invalid_email) unless @user
    return success_response(:created, :send_confirm_email) if @user.send_confirm_email

    error_response(:conflict, :email_already_confirmed)
  end

  private

  def token_not_expired?(verification)
    (verification.created_at + UserVerification::TOKEN_LIFETIME) > Time.now
  end
end
