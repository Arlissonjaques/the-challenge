module AuthenticateRequest
  extend ActiveSupport::Concern
  include ErrorsResponseConcern
  require 'json_web_token'

  def authenticate_user
    return unauthorized unless current_user
  end

  def current_user
    @current_user = nil

    if decoded_token
      data = decoded_token
      user = User.find_by(id: data[:user_id])
      session = Session.search(data[:user_id], data[:token])

      if user && session && !session.is_late?
        session.used
        @current_user ||= user
      end
    end
  end

  def decoded_token
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    if token
      begin
        @decoded_token ||= JsonWebToken.decode(token)
      rescue Error => e
        return unauthorized
      end
    end
  end
end
