require 'rails_helper'

RSpec.describe "MicroPosts", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Users#show" do
    before do
      FactoryBot.send(:user_with_posts, posts_count: 35)
      @user = Micropost.first.user
    end

    it "30件表示されていること" do
      visit user_path @user

      posts_wrapper =
        within "ol.microposts" do
          find_all("li")
        end
      expect(posts_wrapper.size).to eq 30
    end

    it "ページネーションのラッパータグが表示されていること" do
      visit user_path @user
      expect(page).to have_selector "div.pagination"
    end

    it "Micropostの本文がページ内に表示されていること" do
      visit user_path @user
      @user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
    
    it "ページネーションの表示が1箇所のみであること" do
      visit user_path @user
      pagination = find_all("div.pagination")
      expect(pagination.size).to eq 1
    end
  end
end
