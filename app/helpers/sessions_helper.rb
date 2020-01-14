module SessionsHelper
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def login(user)
    session[:user_id] = user.id
  end

  def loggedin?
    !current_user.nil?
  end
end
