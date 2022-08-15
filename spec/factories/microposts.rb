FactoryBot.define do
  factory :orange, class: Micropost do
    content { 'I just ate an orange!' }
    created_at { 10.minutes.ago }
  end

  factory :most_recent, class: Micropost do
    content { 'Writing a short test' }
    created_at { Time.zone.now }
    user { association :user, email: 'recent@example.com' }
  end

  factory :post_by_user, class: Micropost do
    content { "Posted by User" }
    created_at { Time.zone.now }
    user
  end

  factory :post_by_archer, class: Micropost do
    content { "Posted by Archer" }
    created_at { Time.zone.now }
    user factory: :archer
  end

  factory :post_by_lana, class: Micropost do
    content { "Posted by Lana" }
    created_at { Time.zone.now }
    user factory: :lana
  end
end

def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:orange, posts_count, user: user)
  end
end
