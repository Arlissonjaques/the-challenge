class Api::Auth::ConfirmationsController < ApplicationController
  include SessionConcern
  include ResponseConcern

  skip_before_action :authenticate_user

  def confirm_email
    if params[:token].blank?
      return error_response(:unprocessable_entity, :insufficient_params)
    end

    verification = UserVerification.search(:pending, :confirm_email, params[:token])

    return error_response(:unauthorized, :invalid_token) if verification.nil?

    if token_not_expired?(verification)
      verification.user.confirm
      verification.update(status: :done)
      #TODO: redirect to the page that says the email is confirmed successfully or can be redirected to the app
      # redirect_to "#{ENV['REDIRECT_CONFIRM_EMAIL']}?token=#{@token}"
    else
      error_response(:unauthorized, :expired_token)
    end
  end

  def send_confirmation_email
    if params[:email].blank?
      return error_response(:unprocessable_entity, :insufficient_params)
    end

    @user = User.find_by(email: params[:email])

    if @user
      if @user.send_confirm_email
        return success_response(:created, :send_confirm_email)
      else
        return error_response(:conflict, :email_already_confirmed)
      end
    else
      return error_response(:unprocessable_entity, :invalid_email)
    end
  end

  private

  def token_not_expired?(verification)
    (verification.created_at + UserVerification::TOKEN_LIFETIME) > Time.now
  end
end
