json.successful false
json.errors do
  json.array! [
    @error&.full_messages,
    @message
  ].flatten.compact
end
