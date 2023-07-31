json.access_token @token
json.successful true
json.data do
  json.user do
    json.partial! "users/self", user: @user
  end
end