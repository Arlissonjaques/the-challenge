class Api::Auth::SessionsController < ApplicationController
  include SessionConcern

  skip_before_action :authenticate_user, only: :create

  def create
    return error_insufficient_params unless params[:email].present? && params[:password].present?

    @user = User.find_by(email: params[:email])

    if @user
      if @user.authenticate(params[:password])
        @token = session_create(@user.id)
        if @token
          @token = "Bearer #{@token}"
          return success_session_created
        else
          return error_token_create
        end
      else
        return error_invalid_credentials
      end
    else
      return error_invalid_credentials
    end
  end

  def validate_token; end

  def destroy
    token = request.headers['Authorization'].split(' ').last
    data_token = JsonWebToken.decode(token)

    session = Session.find_by(token: data_token[:token])
    session.close_session

    success_session_destroy
  end

  protected

  def success_session_created
    response.headers['Authorization'] = "Bearer #{@token}"
    render json: { status: :created }
  end

  def success_valid_token
    response.headers['Authorization'] = "Bearer #{@token}"
    render status: :ok
  end

  def success_session_destroy
    render status: :no_content, json: {}
  end

  def error_invalid_credentials
    render status: :unauthorized, json: {
      errors: [I18n.t('errors.controllers.auth.invalid_credentials')]
    }
  end

  def error_token_create
    render status: :unprocessable_entity, json: {
      errors: [I18n.t('errors.controllers.auth.token_not_created')]
    }
  end

  def error_insufficient_params
    render status: :unprocessable_entity, json: {
      errors: [I18n.t('errors.controllers.insufficient_params')]
    }
  end
end