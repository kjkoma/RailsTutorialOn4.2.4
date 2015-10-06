class UsersController < ApplicationController

  #
  # action method
  #
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :authenticated_user, only: [:new, :create]

  #
  # REST method
  #
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page:4)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
        sign_in @user
        flash[:success] = "ようこそ、StaticRailsAppへ"
        redirect_to user_path(@user)
    else
        render "new"
    end
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #sign_in @user
      flash[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "#{@user.name}さんを削除しました。"
    redirect_to users_path
  end

  #
  # private method
  #
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # before action
    def signed_in_user
      store_location
      redirect_to signin_path, notice: 'ログインしてください' unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id]) if User.exists?(params[:id])
      redirect_to root_path  unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def authenticated_user
      redirect_to root_path if signed_in?
    end
end
