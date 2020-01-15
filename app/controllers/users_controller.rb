class UsersController < ApplicationController
  before_action :loggedin_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login @user
      flash[:success] = "WELCOME TO THE AUTH SERVER"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "PROFILE UPDATED"
      redirect_to @user
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def loggedin_user
      unless loggedin?
        flash[:danger] = 'PLEASE LOGIN'
        redirect_to login_url
      end
    end
end
