require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    let!(:post) { create(:post) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:text) }
  end

  describe 'associations' do
    it { should belong_to(:author).class_name('User') }
    it { should have_many(:comments).dependent(:destroy) }
  end
end
