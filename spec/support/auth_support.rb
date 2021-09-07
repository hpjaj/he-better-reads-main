def auth_headers(user)
  token = JWTAuth.encode(user_id: user.id)

  { "Authorization" => "Bearer #{token}" }
end
