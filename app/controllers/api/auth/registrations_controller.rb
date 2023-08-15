class Api::Auth::RegistrationsController < ApplicationController
  include SessionConcern
  include ResponseConcern

  skip_before_action :authenticate_user, only: :create

  def create
    @user = User.new(registration_params)

    if @user.save
      success_response(:created)
    else
      error_response(:unprocessable_entity)
    end
  end

  def destroy
    if current_user.destroy
      render status: :no_content, json: {}
    else
      render status: :unprocessable_entity, json: {}
    end
  end

  private

  def registration_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
