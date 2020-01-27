class MicropostsController < ApplicationController
  before_action :loggedin_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end
