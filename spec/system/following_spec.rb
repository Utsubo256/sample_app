require 'rails_helper'

RSpec.describe "Following", type: :system do
  before do
    driven_by(:rack_test)
    # @user = FactoryBot.send(:create_relationships)
    log_in_as @user
  end

  describe "following and followers" do
    # it "followingの数とフォローしているユーザへのリンクが表示されていること" do
      # visit following_user_path(@user)
      # expect(@user.following).to_not be_empty
      # expect(page).to have_content "10 following"
      # @user.following.each do |user|
        # expect(page).to have_link user.name, href: user_path(user)
      # end
    # end
  end

  describe "followers" do
    # it "followersの数とフォローしているユーザへのリンクが表示されていること" do
      # visit followers_user_path(@user)
      # expect(@user.followers).to_not be_emtpy
      # expect(page).to have_content "10 followers"
      # @user.followers.each do |user|
        # expect(page).to have_link user.name, href: user_path(user)
      # end
  #   end
  end
end

