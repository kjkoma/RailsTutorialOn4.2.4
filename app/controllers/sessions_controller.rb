class SessionsController < ApplicationController
  # Sign in Method
  def new
  end

  # Create Session Method
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        sign_in user
        redirect_to user_path(user)
    else
        @input_email = params[:session][:email]
        flash.now[:error] = "Invalid email/password combination"
        render "new"
    end
  end

  # Sign out Method
  def destroy
  end
end
