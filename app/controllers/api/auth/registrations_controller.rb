class Api::Auth::RegistrationsController < ApplicationController
  include SessionConcern
  include ErrorsResponseConcern

  skip_before_action :authenticate_user, only: :destroy

  def create
    @user = User.new(registration_params)

    if @user.save
      success_user_created
    else
      unprocessable_entity(@user.errors.full_messages)
    end
  end

  def destroy
    current_user.destroy
    success_user_destroy
  end

  protected

  def success_user_created
    response.headers['Authorization'] = "Bearer #{@token}"
    render status: :created, template: "auth/auth_success"
  end

  def success_user_destroy
    render status: :no_content, json: {}
  end

  private

  def registration_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
