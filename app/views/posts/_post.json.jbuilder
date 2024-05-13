json.extract! post, :id, :title, :text, :author_id
json.created_at post.created_at.strftime("%d/%m/%Y %H:%M")
