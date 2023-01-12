require 'rails_helper'

describe Item do
  describe 'validations' do
    describe 'presence' do
      it { should validate_presence_of(:item_id) }
      it { should validate_presence_of(:item_created_at) }
      it { should validate_presence_of(:by) }
      it { should validate_presence_of(:item_type) }
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:url) }
    end

    describe 'uniqueness' do
      subject { build(:item) }

      it { should validate_uniqueness_of(:item_id) }
    end
  end
end