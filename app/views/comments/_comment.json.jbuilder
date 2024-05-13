json.extract! comment, :id, :name, :comment, :post_id, :user_id, :created_at
json.created_at comment.created_at.strftime("%d/%m/%Y %H:%M")
