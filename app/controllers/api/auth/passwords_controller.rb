class Api::Auth::PasswordsController < ApplicationController
  include SessionConcern
  include ResponseConcern

  before_action :authenticate_user, only: :reset_password

  def create_reset_password_email
    if params[:email].blank?
      return error_response(:unprocessable_entity, 'insufficient_params')
    end

    @user = User.find_by(email: params[:email])

    return error_response(:unprocessable_entity, 'invalid_email') if @user.nil?
    return error_response(:unauthorized, 'unconfirmed_email') unless @user.email_confirmed?

    @user.send_reset_password_email

    success_response(:created, 'reset_password_email_sent') #TODO: deveria retornar o usuario aqui?
  end

  def verify_reset_email_token
    return error_response(:unprocessable_entity, 'insufficient_params') unless params[:token]

    verification = UserVerification.search(:pending, :reset_email, params[:token])

    return error_response(:unauthorized, 'invalid_token') if verification.nil?

    if (verification.created_at + UserVerification::TOKEN_LIFETIME) > Time.now
      verification.update(status: :done)
      verification.user.confirm unless verification.user.email_confirmed?
      token = session_create(verification.user_id)
      #TODO: redirect to the page where a logged in user can change its password
      # redirect_to "#{ENV['REDIRECT_RESET_EMAIL']}?token=#{token}"
    else
      error_response(:unauthorized, 'expired_token')
    end
  end

  def reset_password
    @user = current_user

    if params[:password].blank? || params[:confirm_password].blank?
      return error_response(:unprocessable_entity, 'insufficient_params')
    end

    if params[:password] != params[:confirm_password]
      return error_response(:unprocessable_entity, 'different_passwords')
    end

    if @user.update(password: params[:password])
      return success_response(:ok, 'email_reset_success')
    else
      return error_response(:unprocessable_entity)
    end
  end
end
