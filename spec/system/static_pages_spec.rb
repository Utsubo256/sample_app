require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'root' do
    it 'root_pathへのリンクが2つ、help, about, contact, Sign up now!へのリンクが表示されていること' do
      visit root_path
      link_to_root = page.find_all("a[href=\"#{root_path}\"]")

      expect(link_to_root.size).to eq 2
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'About', href: about_path
      expect(page).to have_link 'Contact', href: contact_path
      expect(page).to have_link 'Sign up now!', href: signup_path
    end
  end

  describe "home" do
    it "followingとfollowersが正しく表示されること" do
      # user = FactoryBot.send(:create_relationships)
      # log_in_as user
      # expect(page).to have_content "10 following"
      # expect(page).to have_content "10 followers"

      # visit user_path(user)
      # expect(page).to have_content "10 following"
      # expect(page).to have_content "10 followers"
    end
  end
end
