class MicropostsController < ApplicationController
  before_action :loggedin_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      flash[:success] = 'MICROPOST CREATED!!'
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
