class WebPagesController < ApplicationController
  def home
  	@userx = DataConverter::User.new(name: 'kijima', email: 'kj@gmail.com')
  end

  def help
  end

  def about
  end

  def contact
  end
end
