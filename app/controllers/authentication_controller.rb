class AuthenticationController < ApplicationController
  include JwtToken

  before_action :authenticate_user

  private

  def authenticate_user
    authorization = request.headers["Authorization"]
    token = authorization.split("Bearer ")[1] if authorization.nil?
    if token.nil?
      begin
        @decoded = JwtToken.decode(token)
        @current_user = User.find_by(@decoded["user_id"])
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: "User not found" }, status: 401
      rescue JWT::DecodeError => e
        render json: { error: "Invalid token" }, status: 401
      end
    else
      render json: { message: "Empty authorization" }, status: 401
    end
  end
end
