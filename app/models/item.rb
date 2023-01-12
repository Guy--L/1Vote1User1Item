class Item < ApplicationRecord
    
    validates :item_id, presence: true, uniqueness: true
    validates :item_created_at, presence: true
    validates :item_type, presence: true
    validates :by, presence: true
    validates :title, presence: true
    validates :url, presence: true
    
    acts_as_votable
    after_create_commit :broadcast_update

    def broadcast_update
      broadcast_prepend_later_to "items",
        target: "items_list", 
        partial: "items/itemnew", 
        locals: { item: self }
    end
  
    def voter_names
        self.votes_for.includes(:voter).map { |vote| vote.voter.full_name }.join(', ')
    end

    def voter_ids
        self.votes_for.includes(:voter).map { |vote| vote.voter.id }
    end
end
  