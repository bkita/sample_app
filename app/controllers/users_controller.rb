class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(user_id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the sample APP!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User details updated correctly.'
      redirect_to @user
    else
      render 'edit'
    end

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :passwrd_confirmation)
  end

  def user_id
    params[:id]
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:error] = 'Please log in.'
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
