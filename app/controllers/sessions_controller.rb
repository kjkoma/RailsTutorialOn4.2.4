class SessionsController < ApplicationController
  before_action :authenticated_user, only: [:new, :create]

  # Sign in Method
  def new
  end

  # Create Session Method
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        sign_in user
        redirect_back_or user
    else
        @input_email = params[:session][:email]
        flash.now[:error] = "Invalid email/password combination"
        render "new"
    end
  end

  # Sign out Method
  def destroy
    sign_out
    redirect_to root_path
  end

  # private method
  private

    def authenticated_user
      redirect_to root_path if signed_in?
    end
end
