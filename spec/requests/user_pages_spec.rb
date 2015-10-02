require 'rails_helper'

RSpec.describe "User Pages", type: :request do

  subject { page }

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
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

end
