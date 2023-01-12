FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Sam#{n}" }
    sequence(:last_name) { |n| "Iam#{n}" }
    sequence(:email) { |n| "votednews#{n}@example.com" }
    password { 'asdfjk' }
    password_confirmation { 'asdfjk' }
  end
end
