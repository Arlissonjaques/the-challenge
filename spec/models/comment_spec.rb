require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    let!(:comment) { create(:comment) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:comment) }
  end

  describe 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end
end
