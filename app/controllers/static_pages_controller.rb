class StaticPagesController < ApplicationController
  def home
    if loggedin?
      @micropost = current_user.microposts.build if loggedin?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
