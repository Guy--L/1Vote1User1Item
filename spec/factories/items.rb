FactoryBot.define do
  factory :item do
    sequence(:item_id) { |n| n * 100 }
    sequence(:by) { |n| "Writer#{n}" }
    sequence(:title) { |n| "Item Title #{n}" }
    item_created_at { DateTime.now }
    item_type { 'story' }
    url { 'http://example.com' }
  end

  trait :carrying_votes do
    after(:create) do |item|
      create_list(:vote, 2, votable: item)
    end
  end
end
