class Api::Auth::SessionsController < ApplicationController
  include SessionConcern
  include ResponseConcern

  skip_before_action :authenticate_user, only: :create

  def create
    return error_response(:unprocessable_entity, 'insufficient_params') if params[:email].nil? || params[:password].nil?

    @user = User.find_by(email: params[:email])

    return error_response(:unauthorized, 'invalid_credentials') if @user.nil?
    return error_response(:unauthorized, 'unconfirmed_email') unless @user&.email_confirmed?
    return error_response(:unauthorized, 'invalid_credentials') unless @user.authenticate(params[:password])

    @token = session_create(@user.id)
    success_response(:created, '') if @token
  end

  def validate_token; end

  def destroy
    token = request.headers['Authorization'].split(' ').last
    data_token = JsonWebToken.decode(token)

    session = Session.find_by(token: data_token[:token])

    return unless session

    session.close_session
    render json: {}, status: :no_content
  end
end
