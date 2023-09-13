class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user

  #POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      token = jwt_encode({ user_id: @user.id })
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), email: @user[:email] }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
