require 'rails_helper'

RSpec.describe "User Pages", type: :request do

  subject { page }

  describe "index page" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Hitoshi, Kijima", email: "kijima_h@japacom.co.jp")
      FactoryGirl.create(:user, name: "David Beckam", email: "dbeckam@railstutorial.jp")
      visit users_path
    end

    it { should have_title('All Users') }
    it { should have_content('ユーザー一覧') }

    describe "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end

    describe "pagination" do
      before(:all) { 10.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it "should list each user" do
        User.paginate(page: 1, per_page: 10).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          click_link "ログアウト"
          sign_in admin
          visit users_path
        end

        it { should have_link("削除", href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link("削除", match: :first)
          end.to change(User, :count).by(-1)
        end
        it {should_not have_link("削除", href: user_path(admin)) }
      end

      describe "as an non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before do
          click_link "ログアウト"
          sign_in non_admin, no_capybara: true
        end

        describe "submitting as DELETE request to the User#destroy action" do
          before { delete user_path(user) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end
    end

  end

  describe "Sign Up Page" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "名前",          with: "User01"
        fill_in "メールアドレス",  with: "user01@example01.com"
        fill_in "パスワード",      with: "foobar"
        fill_in "確認用パスワード", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "Profile Page" do
    #ユーザー変数を利用する
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit User") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before do
        click_button "保存"
      end

      it { should have_content('エラー') }
    end

    describe "with valid information" do
      let(:new_name) { "Sample User" }
      let(:new_email) { "sample@example.co.jp" }
      before do
        fill_in "名前"         , with: new_name
        fill_in "メールアドレス", with: new_email
        fill_in "パスワード"     , with: user.password
        fill_in "確認用パスワード", with: user.password
        click_button "保存"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.bg-success') }
      it { should have_link('ログアウト', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end

end
