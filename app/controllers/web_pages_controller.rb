class WebPagesController < ApplicationController

  #
  # action method
  #
  # somethind write to action

  #
  # REST method
  #
  def home
  	@userx = DataConverter::User.new(name: 'kijima', email: 'kj@gmail.com')
    if signed_in?
      @micropost = current_user.microposts.build(params[:micropost])
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 6)
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  #
  # private method
  #
  # private
  # something write to private method
end
