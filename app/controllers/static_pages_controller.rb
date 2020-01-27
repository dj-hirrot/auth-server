class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if loggedin?
  end

  def help
  end

  def about
  end

  def contact
  end
end
