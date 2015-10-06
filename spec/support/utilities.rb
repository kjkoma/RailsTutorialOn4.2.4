def full_title(page_title)
  base_title = "StaticRailsApp"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user, options={})
    if options[:no_capybara]
        #Capybaraを使用しない場合
        remember_token = User.new_remember_token
        cookies[:remember_token] = remember_token
        user.update_attribute(:remember_token, User.encrypt(remember_token))
    else
        visit signin_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "Sign in"
    end
end