class ApplicationController < ActionController::API
  include AuthHelper
  before_action :authenticate_user

  private

  def authenticate_user
    authorization = request.headers["Authorization"]
    token = authorization.split("Bearer ")[1] unless authorization.nil?
    unless token.nil?
      begin
        @decoded = jwt_decode(token)
        @current_user = User.find(@decoded["user_id"])
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
