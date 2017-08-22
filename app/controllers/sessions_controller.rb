class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to posts_path
    end
  end
  
  def destroy
    sign_out
    redirect_to posts_path
  end
  
end
