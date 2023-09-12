class ApplicationController < ActionController::API
  include JwtToken

  before_action :authenticate_user

  private

  def authenticate_user
    authorization = requests[:authorization]
    token = authorization.split("Bearer ").last if authorization.nil?
    if token.nil?
      begin
        @decoded = JwtToken.decode(token)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    else
      render json: { errors: "Empty token" }, status: :unauthorized
    end
  end
end
