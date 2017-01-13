class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in(user)
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      flash[:info] = 'Invalid token.'
      redirect_to root_url
    end
  end
end
