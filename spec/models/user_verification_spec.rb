# spec/models/user_verification_spec.rb

require 'rails_helper'

RSpec.describe UserVerification, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let!(:user_verification1) { create(:user_verification, token: '6UgefsZddjVT33apH7uQ8tshW6nMZ2TP') }
    let!(:user_verification2) { create(:user_verification, token: '6UgefsZddjVT33apH7uQ8tshW6nMZ2TP') }

    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[pending done failed]) }
    it { should validate_presence_of(:verify_type) }
    it { should validate_inclusion_of(:verify_type).in_array(%w[confirm_email reset_email]) }

    it 'must return different tokens' do
      expect(user_verification2.token).to_not eq(user_verification1.token)
    end
  end

  describe 'methods' do
    describe '.search' do
      let!(:user_verification_pending) { create(:user_verification, status: 'pending', verify_type: 'confirm_email') }
      let!(:user_verification_done) { create(:user_verification, status: 'done', verify_type: 'reset_email') }

      it 'returns matching user verification' do
        result = UserVerification.search('pending', 'confirm_email', user_verification_pending.token)
        expect(result).to eq(user_verification_pending)
      end

      it 'returns nil if no matching user verification' do
        result = UserVerification.search('done', 'confirm_email', user_verification_pending.token)
        expect(result).to be_nil
      end
    end

    describe '#generate_token' do
      it 'generates a unique token' do
        user_verification = build(:user_verification)
        allow(SecureRandom).to receive(:base58).and_return('unique_token')

        user_verification.generate_token

        expect(user_verification.token).to eq('unique_token')
      end
    end
  end
end
