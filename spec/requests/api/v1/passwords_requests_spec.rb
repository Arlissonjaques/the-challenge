require 'rails_helper'
require 'json_web_token'
include ApiAsJsonHelper

RSpec.describe Api::Auth::PasswordsController, type: :request do
  describe 'POST #forgot_password' do
    let!(:user) { create(:user, email: 'email@teste.com') }

    xcontext 'when the email is valid' do
      before do
        post api_auth_forgot_password_path, params: { 'email': user.email }
      end

      it 'sends a reset password email' do
      end

      it 'returns a success response' do
      end
    end

    context 'when the email is blank' do
      before do
        post api_auth_forgot_password_path, params: { email: '' }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(422)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include('Insufficient parameters')
      end
    end

    context 'when the user does not exist' do
      before do
        user.destroy
        post api_auth_forgot_password_path, params: { email: 'email@teste.com' }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(422)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include('No user found with this email')
      end
    end

    context 'when the email is not confirmed' do
      before do
        user.update(email_confirmed_at: nil)
        post api_auth_forgot_password_path, params: { email: user.email }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(401)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include('Before you must confirm your email')
      end
    end
  end

  describe 'GET #verify_reset_email_token' do
    let!(:user) { create(:user) }
    let(:user_verification) do
      create(
        :user_verification,
        verify_type: :reset_email
      )
    end

    before do
      get api_auth_verify_reset_password_token_path,
        params: { token: user_verification.token }
    end

    context 'when the token is valid and within expiration' do
      it 'confirms the user if the email is not confirmed' do
        expect(user.email_confirmed_at).not_to be_nil
        expect(user_verification.reload.status).to eq('done')
      end
    end

    context 'when the token is blank' do
      before do
        get api_auth_verify_reset_password_token_path, params: { token: '' }
      end

      it 'should fail the check' do
        expect(response).to have_http_status(422)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include('Insufficient parameters')
      end
    end

    context 'when the token is present but invalid' do
      before do
        get api_auth_verify_reset_password_token_path, params: { token: '7oken-1nv@l1d0' }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(401)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include('Invalid_token')
      end
    end

    context 'when the token has expired' do
      let!(:user_verification) do 
        create(
          :user_verification,
          created_at: 2.days.ago,
          verify_type: :reset_email
        )
      end

      before do
        get api_auth_verify_reset_password_token_path,
          params: { token: user_verification.token }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(401)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include('Expired token')
      end
    end
  end

  describe 'PUT #reset_password' do
    let(:user) { create(:user, password: '0ld5Up3r53nh@') }

    context 'when the user is logged in' do
      context 'when it has empty values' do
        let(:params) do
          {
            'current_password': '',
            'new_password': '',
            'confirm_password': ''
          }
        end

        before do
          put api_auth_reset_password_path,
            headers: authenticated_header,
            params: params
        end

        it 'returns an error response' do
          expect(response).to have_http_status(422)
          expect(parsed_body[:successful]).to be false
          expect(parsed_body[:errors]).to include('Insufficient parameters')
        end
      end

      context 'when the current password is not valid' do
        let(:params) do
          {
            'current_password': 'senha-errada',
            'new_password': 'n3w5Up3r53nh@',
            'confirm_password': 'n3w5Up3r53nh@'
          }
        end

        before do
          put api_auth_reset_password_path,
            headers: authenticated_header,
            params: params
        end

        it 'returns an error response' do
          expect(response).to have_http_status(422)
          expect(parsed_body[:successful]).to be false
          expect(parsed_body[:errors]).to include('The current password is invalid')
        end
      end

      context 'when the new password and confirm password are different' do
        let(:params) do
          {
            'current_password': '0ld5Up3r53nh@',
            'new_password': 'n3w5Up3r53nh@',
            'confirm_password': 'diferente'
          }
        end

        before do
          user.update(password: '0ld5Up3r53nh@')

          put api_auth_reset_password_path,
            headers: authenticated_header,
            params: params
        end

        it 'returns an error response' do
          expect(response).to have_http_status(422)
          expect(parsed_body[:successful]).to be false
          expect(parsed_body[:errors]).to include('Password and confirm password must be the same')
        end
      end

      context 'when the new password is not in the correct format' do
        let(:params) do
          {
            'current_password': '0ld5Up3r53nh@',
            'new_password': 'senha-invalida',
            'confirm_password': 'senha-invalida'
          }
        end

        before do
          put api_auth_reset_password_path,
            headers: authenticated_header,
            params: params
        end

        it 'returns an error response' do
          expect(response).to have_http_status(422)
          expect(parsed_body[:successful]).to be false
          expect(parsed_body[:errors]).to include(
            'Password must be at least 8 characters ' \
            'long including letters, numbers ' \
            "and some special character: [!\#@%$]"
          )
        end
      end

      context 'when all values are correct' do
        let(:params) do
          {
            'current_password': '0ld5Up3r53nh@',
            'new_password': 'n3w5Up3r53nh@',
            'confirm_password': 'n3w5Up3r53nh@'
          }
        end

        before do
          put api_auth_reset_password_path,
            headers: authenticated_header,
            params: params
        end

        it 'resets the password' do
          expect(user.reload.authenticate(params[:current_password])).to be false
          expect(user.reload.authenticate(params[:new_password])).to eq(user)
        end

        it 'returns a success response' do
          expect(response).to have_http_status(200)
          expect(parsed_body[:successful]).to be true
          expect(parsed_body[:message]).to eq('Password successfully updated')
        end
      end
    end

    context 'when the user is not logged in' do
      let(:params) do
        {
          'current_password': '0ld5Up3r53nh@',
          'new_password': 'n3w5Up3r53nh@',
          'confirm_password': 'n3w5Up3r53nh@'
        }
      end

      before do
        put api_auth_reset_password_path,
          params: params
      end

      it 'should return a not logged in error' do
        expect(response).to have_http_status(401)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include(
          'You are not authenticated. Please login to access this feature'
        )
      end
    end
  end
end
