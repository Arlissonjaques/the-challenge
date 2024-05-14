module BodyParsedHelper
  def parsed_body
    JSON.parse(response.body, symbolize_names: true)
  end

  def post_parsed(post)
    {
      id: post.id,
      title: post.title,
      text: post.text,
      author_id: post.author_id,
      created_at: post.created_at.strftime("%d/%m/%Y %H:%M")
    }
  end

  def comment_parsed(comment)
    {
      id: comment.id,
      name: comment.name,
      post_id: comment.post_id,
      user_id: comment.user_id,
      created_at: comment.created_at.strftime("%d/%m/%Y %H:%M")
    }
  end
end
