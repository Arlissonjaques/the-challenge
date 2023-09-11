module ApiAsJsonHelper
  def parsed_body
    JSON.parse(response.body, symbolize_names: true)
  end

  def login_params
    {
      email: user.email,
      password: user.password
    }
  end

  def authenticated_header
    post api_auth_sign_in_path, params: login_params

    { Authorization: "Bearer #{parsed_body[:access_token]}" }
  end
end
