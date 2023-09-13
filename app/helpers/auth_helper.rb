require "jwt"

module AuthHelper
  SECRET_KEY = Rails.application.credentials.jwt_secret_key.to_s

  def jwt_encode(payload, exp: Rails.application.credentials.jwt_expired.to_i.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
