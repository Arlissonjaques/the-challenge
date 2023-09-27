require 'rails_helper'
include ApiAsJsonHelper

RSpec.describe Api::Auth::ConfirmationsController, type: :request do
  describe 'GET #confirm_email' do
    let(:user) { create(:user) }
    let!(:correct_verification) do
      create(
        :user_verification,
        verify_type: :confirm_email,
        user:
      )
    end
    let!(:expiraed_verification) do
      create(
        :user_verification,
        verify_type: :confirm_email,
        user:,
        created_at: 1.week.ago
      )
    end

    context 'when the token is valid and not expired' do
      before do
        get api_auth_confirm_email_path,
            params: { token: correct_verification.token }
      end

      it 'confirms the user email' do
        # TODO: alterar esse teste apos os envios de email serem adicionados.
        expect(response).to have_http_status(204)
        expect(user.reload.email_confirmed_at).not_to be_nil
      end
    end

    context 'when the token is blank' do
      it 'returns an unprocessable entity error' do
        get api_auth_confirm_email_path, params: { token: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_body[:errors]).to include('Insufficient parameters')
      end
    end

    context 'when the token is valid but expired' do
      before do
        get api_auth_confirm_email_path, params: { token: expiraed_verification.token }
      end

      it 'returns an unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body[:errors]).to include('Expired token')
      end
    end

    context 'when the token is valid but does not correspond to a pending confirmation' do
      before do
        correct_verification.update(status: :done)
        get api_auth_confirm_email_path, params: { token: correct_verification.token }
      end

      it 'returns an unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body[:errors]).to include('Invalid token')
      end
    end
  end

  describe 'POST #send_confirmation_email' do
    let(:valid_email) { 'naruto.uzumaki@oshokage.com' }
    let(:invalid_email) { 'madara.uchiha@oshokages.com' }
    let!(:user) { create(:user, email: valid_email) }

    context 'when email is valid and user exists' do
      before do
        allow_any_instance_of(User).to receive(:send_confirm_email)
          .and_return(true) # remover quando o envio de email for implementado

        post api_auth_send_confirmation_email_path, params: { email: valid_email }
      end

      it 'sends a confirmation email' do
        expect(response).to have_http_status(:created)
        expect(parsed_body[:message]).to eq('Confirmation email sent successfully')
      end
    end

    context 'when email is valid but user already confirmed' do
      before do
        user.confirm
        post api_auth_send_confirmation_email_path, params: { email: valid_email }
      end

      it 'returns a conflict error' do
        expect(response).to have_http_status(:conflict)
        expect(parsed_body[:errors]).to include('Failed to confirm email or email has already been confirmed')
      end
    end

    context 'when email is valid but confirmation email sending fails' do
      before do
        allow_any_instance_of(User).to receive(:send_confirm_email)
          .and_return(false)

        user.update(email_confirmed_at: nil)
        post api_auth_send_confirmation_email_path, params: { email: valid_email }
      end

      it 'returns an internal server error' do
        expect(response).to have_http_status(409)
        expect(parsed_body[:errors]).to include('Failed to confirm email or email has already been confirmed')
      end
    end

    context 'when email is invalid and user does not exist' do
      before do
        post api_auth_send_confirmation_email_path, params: { email: invalid_email }
      end

      it 'returns an unprocessable entity error' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_body[:errors]).to include('No user found with this email')
      end
    end

    context 'when email parameter is missing' do
      before do
        post api_auth_send_confirmation_email_path, params: { email: '' }
      end

      it 'returns an unprocessable entity error' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_body[:errors]).to include('Insufficient parameters')
      end
    end
  end
end
