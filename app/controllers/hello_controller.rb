class HelloController < ApplicationController
  def index
  	# ここでrenderを実行するとviewファイル（index.html.erb）は呼び出されない
    # render text: 'Hello World!'
  end
end