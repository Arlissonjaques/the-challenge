module AuthenticateRequest
  extend ActiveSupport::Concern
  include ResponseConcern
  require 'json_web_token'

  def authenticate_user
    return error_response(:unauthorized, 'unauthenticated') unless current_user
  end

  def current_user
    @current_user = nil
    token = decoded_token

    if token
      data = token
      user = User.find_by(id: data[:user_id])
      session = Session.search(data[:user_id], data[:token])

      if user && session && !session.expired?
        session.last_used
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
        return error_response(:unauthorized, 'unauthenticated')
      end
    end
  end
end
