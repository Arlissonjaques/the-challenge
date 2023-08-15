# binding.pry
json.successful false
json.errors do
  json.array! [
    @user&.errors&.full_messages,
    @error_message
  ].flatten.compact
end
