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
      it { should have_selector('div.alert.bg-error', text: 'Invalid') }
    end

    describe "when valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "メールアドレス",  with: user.email.upcase
        fill_in "パスワード"   ,   with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('プロフィール', href: user_path(user)) }
      it { should have_link('設定', href: edit_user_path(user)) }
      it { should have_link('ユーザー一覧', href: users_path) } 
      it { should have_link('ログアウト', href: signout_path) }
      it { should_not have_link('ログイン', href: signin_path) }

      describe "followed by signout" do
        before { click_link "ログアウト" }
        it { should have_link('ログイン') }
      end
    end
  end

  describe "Authorization" do

    describe "for non-singed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the index page" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "when attempting to visit a protected page" do
        before do 
          visit edit_user_path(user)
          fill_in "メールアドレス", with: user.email
          fill_in "パスワード", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit User')
          end
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@railstutorial.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit User')) }
        specify { expect(response).to redirect_to(root_path) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as another user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:another_user) { FactoryGirl.create(:user, email: "kijima_h@japacom.co.jp") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(another_user) }
        specify { expect(response.body).not_to match(full_title('Edit User')) }
        specify { expect(response).to redirect_to(root_path) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(another_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

  end

end
