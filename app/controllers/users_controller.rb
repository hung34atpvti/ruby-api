class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  before_action :find_user, only: [:show, :update, :destroy]

  def index
    @users = User.all.map { |user| user.attributes.except("password_digest") }
    render json: @users, status: 200
  end

  def show
    user_without_password = @user.attributes.except("password_digest")
    render json: user_without_password, status: 200
  end

  def create
    @user = User.new(email: params[:email], name: params[:name], password: user_params[:password], password_confirmation: user_params[:password])
    if @user.save
      user_without_password = @user.attributes.except("password_digest")
      render json: user_without_password, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 200
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
