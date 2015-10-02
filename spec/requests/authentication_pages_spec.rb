require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do

  subject { page }

  describe "Sign in page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('| Sign in') }

    describe "when invalid information" do
      before { click_button "Sign in" }

      it { should have_content('Sign in') }
      it { should have_selector('div.alert bg-error', text: 'Invalid') }
    end

    describe "when valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "メールアドレス",  with: user.email.upcase
        fill_in "パスワード"   ,   with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sing in', href: signin_path) }
    end

  end

end
