class MicropostsController < ApplicationController

  #
  # action method
  #
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  #
  # REST method
  #
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
        flash[:success] = "投稿内容を送信しました。"
        redirect_to root_path
    else
        @userx = DataConverter::User.new(name: 'kijima', email: 'kj@gmail.com')
        @feed_items = []
        render 'web_pages/home'
    end

  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to request.referer
  end

  #
  # private method
  #
  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      if @micropost.nil?
        flash[:error] = "削除対象の投稿が見つかりませんでした。"
        redirect_to request.referer
      end
    end

end
