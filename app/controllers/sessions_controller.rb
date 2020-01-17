class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        login @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = "ACCOUNT NOT ACTIVATED."
        message += "CHECK YOUR EMAIL FOR THE ACTIVATE LINK"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'INVALID EMAIL/PASSWORD COMBINATION'
      render :new
    end
  end

  def destroy
    logout if loggedin?
    redirect_to root_url
  end
end
