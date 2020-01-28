class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private
    def loggedin_user
      unless loggedin?
        store_location
        flash[:danger] = 'PLEASE LOGIN'
        redirect_to login_url
      end
    end
end
