# spec/models/session_spec.rb

require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let!(:user) { create(:user) }
    let!(:session1) { create(:session, user: user) }
    let!(:session2) { create(:session, user: user) }

    it 'must generate a unique token on create' do
      expect(session2.token).not_to eq(session1.token)
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let!(:session) { create(:session, user: user) }

    describe '.search' do
      it 'returns a matching session' do
        result = Session.search(session.user_id, session.token)

        expect(result).to eq(session)
      end

      it 'returns nil if no matching session' do
        result = Session.search(session.user_id, 'non_existent_token')

        expect(result).to be_nil
      end

      it 'returns nil for an expired session' do
        session.update(status: false)
        result = Session.search(session.user_id, session.token)

        expect(result).to be_nil
      end
    end

    describe '#expired?' do
      it 'returns true for an expired session' do
        session.update(last_used_at: 2.hours.ago)

        expect(session.expired?).to be(true)
      end

      it 'returns false for an active session' do
        expect(session.expired?).to be(false)
      end

      it 'sets session status to false for an expired session' do
        session.update(last_used_at: 2.hours.ago)
        expect { session.expired? }.to change { session.status }.to(false)
      end
    end

    describe '#last_used' do
      it 'updates the last_used_at attribute' do
        expect { session.last_used }.to change { session.last_used_at }
      end
    end

    describe '#close_session' do
      it 'sets the session status to false' do
        expect { session.close_session }.to change { session.status }.to(false)
      end
    end

    describe '#generate_token' do
      it 'generates a unique token' do
        session = build(:session)
        allow(SecureRandom).to receive(:base58).and_return('unique_token')

        session.generate_token

        expect(session.token).to eq('unique_token')
      end
    end
  end
end
