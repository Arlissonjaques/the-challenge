require 'rails_helper'
include ApiAsJsonHelper

RSpec.describe Api::Auth::SessionsController, type: :request do
  describe 'POST #create' do
    context 'when credentials are valid' do
      let!(:user) { create(:user) }

      before { post api_auth_sign_in_path, params: login_params }

      it 'should create a user session successfully' do
        expect(response).to have_http_status(201)
      end

      it 'should return successful true' do
        expect(parsed_body[:successful]).to be true
      end

      it 'should return the access-token' do
        expect(parsed_body[:access_token]).to be_present
      end
    end

    context 'when credentials are invalid' do
      let!(:user) { create(:user) }

      context 'when the password is incorrect' do
        before do
          params = { email: user.email, password: 's3nh@' }
          post api_auth_sign_in_path, params:
        end

        it 'returns status 401 (Unauthorized)' do
          expect(response).to have_http_status(401)
        end

        it 'returns an appropriate error message' do
          expect(parsed_body[:errors]).to include('Invalid email or password')
        end
      end

      context 'when the email is incorrect' do
        before do
          params = { email: 'email@test.com', password: user.password }
          post api_auth_sign_in_path, params:
        end

        it 'returns status 401 (Unauthorized)' do
          expect(response).to have_http_status(401)
        end

        it 'returns an appropriate error message' do
          expect(parsed_body[:errors]).to include('Invalid email or password')
        end
      end
    end

    context 'when the email is not confirmed' do
      let(:user) { create(:user, email_confirmed_at: nil) }

      before { post api_auth_sign_in_path, params: login_params }

      it 'returns status 401 (Unauthorized)' do
        expect(response).to have_http_status(401)
      end

      it 'returns an error message indicating the email is not confirmed' do
        expect(parsed_body[:errors]).to include('Before you must confirm your email')
      end
    end

    context 'when parameters are missing' do
      let(:user) { create(:user) }

      before { post api_auth_sign_in_path, params: {} }

      it 'returns status 422 (Unprocessable Entity)' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message indicating insufficient parameters' do
        expect(parsed_body[:errors]).to include('Insufficient parameters')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the session is successfully terminated' do
      let(:user) { create(:user) }
      let(:session) { user.sessions.last }

      before do
        delete api_auth_sign_out_path, headers: authenticated_header
      end

      it 'returns status 204 (No Content)' do
        expect(response).to have_http_status(204)
      end

      it 'terminates the session in the database' do
        expect(session.status).to be false
      end
    end

    # TODO: Add failure context.
  end
end
