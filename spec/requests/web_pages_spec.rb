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

end
