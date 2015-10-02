require 'rails_helper'

RSpec.describe "This is Static Web Pages Test", type: :request do

  describe "Get Home Page" do
    it "works! (now write some real specs)" do
      #get web_pages_index_path
      get '/'
      expect(response).to have_http_status(200)
    end

    it "should have welcome contents" do
      visit root_path
      expect(page).to have_content('Welcom, Report Share Site!!')
    end
  end

  describe "GET Help Page Contents" do
    it "shoud have help contents" do
    	visit  help_path
    	expect(page).to have_content('Could you help us')
    end
  end

  describe "GET About Page Contents" do
    it "shoud have about contents" do
      visit  about_path
      expect(page).to have_content('このサイトはRuby on Railsを利用した静的なページを表示するアプリケーションです。')
    end
  end

  describe "GET Contact Page Contents" do
    it "shoud have contact contents" do
      visit  contact_path
      expect(page).to have_content('Contact')
    end
  end
end
