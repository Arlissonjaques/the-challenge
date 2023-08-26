require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it do
      should validate_presence_of(:email)
        .with_message(I18n.t('errors.models.user.format_email'))
    end

    it do
      should validate_presence_of(:password)
        .with_message(I18n.t('errors.models.user.format_password'))
    end

    context 'with email in the correct format' do
      it 'must accept the formats' do
        should allow_value('user@example.com').for(:email)
        should allow_value('another_user@test.com').for(:email)
      end
    end

    context 'with email in the wrong format' do
      it 'must not accept the formats' do
        should_not allow_value('invalid_email').for(:email)
        should_not allow_value('email @email.com').for(:email)
        should_not allow_value('email{}@email.com').for(:email)
      end
    end
  end

  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:user_verifications).dependent(:destroy) }
  end

  describe 'enum' do
    it { should define_enum_for(:role).with_values(admin: 0, user: 1) }
  end

  describe 'callbacks' do
    describe '#downcase_email!' do
      it 'converts email to lowercase' do
        user = FactoryBot.build(:user, email: 'TesT@ExAmPlE.coM')
        user.downcase_email!

        expect(user.email).to eq('test@example.com')
      end

      it 'handles nil email' do
        user = FactoryBot.build(:user, email: nil)
        user.downcase_email!

        expect(user.email).to be_nil
      end
    end
  end

  describe 'methods' do
    describe '#email_confirmed?' do
      let(:user) { create(:user) }

      it 'returns true when email is confirmed' do
        expect(user.email_confirmed?).to be_truthy
      end

      it 'returns false when email is not confirmed' do
        user.update(email_confirmed_at: false)

        expect(user.email_confirmed?).to be_falsy
      end      
    end

    describe '#confirm' do
      let(:user) { create(:user, email_confirmed_at: nil) }

      it 'should confirms the email' do
        user.confirm

        expect(user.email_confirmed_at).to_not be_nil
      end

      it 'when the method is not called, it must return nil' do
        expect(user.email_confirmed_at).to be_nil
      end
    end

    describe '#send_confirm_email' do
    end

    describe '#send_reset_password_email' do
    end
  end
end
