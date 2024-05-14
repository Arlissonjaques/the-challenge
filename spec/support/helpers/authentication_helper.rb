require 'json_web_token'

module AuthenticationHelper
  def authenticated_header
    session = user.sessions.build
    session_token = session.token if session.save

    payload = {
      user_id: user.id,
      token: session_token
    }

    { Authorization: "Bearer #{JsonWebToken.encode(payload)}" }
  end
end
