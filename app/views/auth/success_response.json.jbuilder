json.access_token @token if @token.present?
json.successful true
json.message @message if @message.present?
json.data do
  json.user do
    json.partial! "users/self", user: @user
  end
end
