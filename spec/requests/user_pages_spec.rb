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

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following user" do
        before {visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followed count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
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

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end

end
