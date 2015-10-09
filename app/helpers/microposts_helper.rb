module MicropostsHelper

  # このメソッドは実際には利用しない
  # CSSのword-wrapを利用した方がバランスが良い
  # 利用する場合、<span><%= wrap(feed_item.content) %></span>のように利用する
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s)}.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
    end

end
