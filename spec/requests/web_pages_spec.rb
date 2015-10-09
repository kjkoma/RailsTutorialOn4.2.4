require 'rails_helper'

RSpec.describe "This is Static Web Pages Test", type: :request do

  describe "Get Root Test" do
    it "works! (now write some real specs)" do
      #get web_pages_index_path
      get '/'
      expect(response).to have_http_status(200)
    end
  end

  describe "Route Static Pages Test" do
    subject { page }

    describe "Home" do
      before { visit root_path }
      it { should have_content('Welcom, Report Share Site!!') }
      it { should have_title('StaticRailsApp') }
      #it { should_not have_title('| Home') }
      it { should have_title('| Home') }
    end

    describe "Help" do
      before { visit help_path }

      it { should have_content('Could you help us') }
      it { should have_title('| Help') }
    end

    describe "About" do
      before { visit about_path }

      it { should have_content('このサイトはRuby on Railsを利用した静的なページを表示するアプリケーションです。') }
      it { should have_title('| About Us') }
    end

    describe "Content" do
      before { visit contact_path }

      it { should have_content('Contact') }
      it { should have_title('| Contact') }
    end
  end

  describe "Home Page" do
    subject { page }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render ther user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 follower", href: followers_user_path(user)) }
      end
    end
  end

end
