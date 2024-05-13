json.array! @comments do |comment|
  partial! "comments/comment", as: :comment
end
