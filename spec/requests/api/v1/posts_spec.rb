require 'rails_helper'
include BodyParsedHelper
include AuthenticationHelper

RSpec.describe Api::V1::PostsController, type: :request do
  describe 'GET /api/v1/posts' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
  
    context 'when user is logged in' do
      it 'returns a success response' do
        get api_v1_posts_path, headers: authenticated_header

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data].first).to include(post_parsed(post))
      end
    end

    context 'when user is not logged in' do
      it 'returns a success response' do
        get api_v1_posts_path

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data].first).to include(post_parsed(post))
      end
    end
  end

  describe 'GET /api/v1/posts/:id' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
  
    context 'when user is logged in' do
      it 'returns a success response' do
        get api_v1_post_path(post.id), headers: authenticated_header

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data]).to include(post_parsed(post))
      end
    end

    context 'when user is not logged in' do
      it 'returns a success response' do
        get api_v1_post_path(post.id)

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data]).to include(post_parsed(post))
      end
    end
  end

  describe 'POST /api/v1/posts' do
    let!(:user) { create(:user) }
    let!(:postx) { create(:post) }
    let(:valid_attributes) do
      {
        title: 'Test Title',
        text: 'Test Text',
        author_id: user.id
      }
    end

    context 'when user is logged in' do
      context 'with valid params' do
        it 'creates a new post' do
          expect {
            post api_v1_posts_path, params: valid_attributes, headers: authenticated_header
          }.to change(Post, :count).by(1)

          expect(response).to have_http_status(:created)
          expect(parsed_body[:successful]).to be true
        end
      end

      context 'with invalid params' do
        it 'returns unprocessable_entity status' do
          post api_v1_posts_path, params: {
            title: '',
            text: '',
            author_id: user.id
          }

          expect(response).to have_http_status(:unauthorized)
          expect(parsed_body[:successful]).to be false
          expect(parsed_body[:errors]).to include(
            'You are not authenticated. Please login to access this feature'
          )
        end
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        post api_v1_posts_path, params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/v1/posts/:id' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, title: 'The old title') }
    let(:new_attributes) { { title: 'The new title' } }

    context 'when user is logged in' do
      context 'with valid params' do
        it 'updates the requested post' do
          put api_v1_post_path(post), params: new_attributes, headers: authenticated_header

          expect(response).to have_http_status(:ok)
          expect(parsed_body[:successful]).to be true  
          expect(post.reload.title).to eq('The new title')
        end
      end

      context 'with invalid params' do
        it 'returns unprocessable_entity status' do
          put api_v1_post_path(post), params: { title: '' }, headers: authenticated_header

          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_body[:successful]).to be false
          expect(post.reload.title).to eq("The old title")
          expect(parsed_body[:errors]).to include("Title can't be blank")
        end
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        put api_v1_post_path(post), params: new_attributes

        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include(
          'You are not authenticated. Please login to access this feature'
        )
      end
    end
  end

  describe 'DELETE /api/v1/posts/:id' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }

    context 'when user is logged in' do
      it 'destroys the requested post' do
        delete api_v1_post_path(post), headers: authenticated_header

        expect(response).to have_http_status(:no_content)
        expect(Post.exists?(post.id)).to be_falsey
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        delete api_v1_post_path(post)

        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include(
          'You are not authenticated. Please login to access this feature'
        )
      end
    end
  end
end
