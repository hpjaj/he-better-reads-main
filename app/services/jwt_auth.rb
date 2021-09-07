# @see https://github.com/jwt/ruby-jwt#expiration-time-claim
#
class JWTAuth
  EXPIRATION = 1.month.to_i

  # @param user_id [Integer] A User#id
  # @param expiration [Integer] An optional number of seconds, from the current time, when the JWT should expire
  # @param payload [Hash] An optional hash of additional payload contents
  # @return [String] A JWT
  #
  def self.encode(user_id:, expiration: nil, payload: {})
    expires_at = expiration.presence || Time.now.to_i + EXPIRATION
    payload    = { user_id: user_id, exp: expires_at }.merge(payload)

    JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
  end

  # @param token [String] An encoded JWT
  # @return [Hash] A hash of the JWT's payload, i.e. { "user_id" => 1, "exp" => 1633663978 }
  #
  def self.decode!(token)
    JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' }).first
  rescue JWT::ExpiredSignature => e
    raise ArgumentError, 'Token has expired'
  rescue JWT::DecodeError => e
    raise ArgumentError, 'Token does not match decoding algorithm and key'
  end
end
