module SessionConcern
  extend ActiveSupport::Concern
  require 'json_web_token'

  def session_create(user_id)
    user = User.find_by(id: user_id)
    session = user.sessions.build

    if user && session.save
      JsonWebToken.encode({user_id: user_id, token: session.token})
    else
      nil
    end
  end
end 
