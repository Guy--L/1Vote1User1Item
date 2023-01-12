FactoryBot.define do
    factory :vote, class: ActsAsVotable::Vote do
        association :votable, factory: :item
        association :voter, factory: :user
    end
end