class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      user.generate_token && user.save
      session[:token] = user.token
      redirect_to '/'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:token] = nil
    redirect_to '/login'
  end

end