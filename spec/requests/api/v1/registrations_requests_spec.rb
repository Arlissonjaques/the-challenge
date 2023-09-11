require 'rails_helper'
include ApiAsJsonHelper

RSpec.describe Api::Auth::RegistrationsController, type: :request do
  describe 'POST #create' do
    context 'when registration is successful' do
      let(:valid_params) do
        {
          first_name: 'Naruto',
          last_name: 'Uzumaki',
          email: 'uzumaki.hokage@hokage.com',
          password: 'S3nh@F0rt3'
        }
      end

      it 'creates a new user' do
        post api_auth_sign_up_path, params: valid_params
        expect(response).to have_http_status(201)
      end

      it 'returns a success response' do
        post api_auth_sign_up_path, params: valid_params
        expect(parsed_body[:successful]).to be true
      end
    end

    context 'when registration fails' do
      context 'when the email is not in the correct format' do
        let(:invalid_params) do
          {
            first_name: 'John',
            last_name: 'Doe',
            email: 'invalid-email',
            password: 'S3nh@F0rt3'
          }
        end

        it 'does not create a new user' do
          post api_auth_sign_up_path, params: invalid_params
          expect(response).to have_http_status(422)
        end

        it 'returns an error response' do
          post api_auth_sign_up_path, params: invalid_params
          expect(parsed_body[:errors]).to include('Email needs to be in the correct format such as: example@email.com')
        end
      end

      context 'when the name is empty' do
        let(:invalid_params) do
          {
            first_name: '',
            last_name: 'Uzumaki',
            email: 'uzumaki.hokage@hokage.com',
            password: 'S3nh@F0rt3'
          }
        end

        it 'does not create a new user' do
          post api_auth_sign_up_path, params: invalid_params
          expect(response).to have_http_status(422)
        end

        it 'returns an error response' do
          post api_auth_sign_up_path, params: invalid_params
          expect(parsed_body[:errors]).to include("First name can't be blank")
        end
      end

      context 'when the password is not in the correct format' do
        let(:invalid_params) do
          {
            first_name: 'Naruto',
            last_name: 'Uzumaki',
            email: 'uzumaki.hokage@hokage.com',
            password: '123abc'
          }
        end

        it 'does not create a new user' do
          post api_auth_sign_up_path, params: invalid_params
          expect(response).to have_http_status(422)
        end

        it 'returns an error response' do
          post api_auth_sign_up_path, params: invalid_params

          expect(parsed_body[:errors]).to include(
            'Password must be at least 8 characters ' \
            'long including letters, numbers ' \
            "and some special character: [!\#@%$]"
          )
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user account is successfully deleted' do
      let(:user) { create(:user) }

      before do
        delete api_auth_destroy_path, headers: authenticated_header
      end

      it 'returns status 204 (No Content)' do
        expect(response).to have_http_status(204)
      end

      it 'deletes the user account' do
        expect(User.exists?(user.id)).to be_falsey
      end
    end

    context 'when user account deletion fails' do
      let(:user) { create(:user) }

      before do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
        delete api_auth_destroy_path, headers: authenticated_header
      end

      it 'returns status 422 (Unprocessable Entity)' do
        expect(response).to have_http_status(422)
      end

      it 'does not delete the user account' do
        expect(User.exists?(user.id)).to be_truthy
      end
    end

    context 'when user is not authenticated' do
      let(:user) { create(:user) }

      before do
        delete api_auth_destroy_path
      end

      it 'returns status 401 (Unauthorized)' do
        expect(response).to have_http_status(401)
      end

      it 'does not delete the user account' do
        expect(User.exists?(user.id)).to be_truthy
      end

      it 'should return an error message about authentication' do
        expect(parsed_body[:errors]).to include(
          'You are not authenticated. ' \
          'Please login to access this feature'
        )
      end
    end
  end
end
