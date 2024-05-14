require 'rails_helper'
include BodyParsedHelper
include AuthenticationHelper

RSpec.describe Api::V1::CommentsController, type: :request do
  describe 'GET /api/v1/comments' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment) }
    # let!(:post) { create(:post) }
  
    context 'when user is logged in' do
      it 'returns a success response' do
        get api_v1_comments_path, headers: authenticated_header

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data].first).to include(comment_parsed(comment))
      end
    end

    context 'when user is not logged in' do
      it 'returns a success response' do
        get api_v1_comments_path

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data].first).to include(comment_parsed(comment))
      end
    end
  end

  describe 'GET /api/v1/comments/:id' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment) }
  
    context 'when user is logged in' do
      it 'returns a success response' do
        get api_v1_comment_path(comment.id), headers: authenticated_header

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data]).to include(comment_parsed(comment))
      end
    end

    context 'when user is not logged in' do
      it 'returns a success response' do
        get api_v1_comment_path(comment.id)

        expect(response).to have_http_status(:ok)
        expect(parsed_body[:successful]).to be true
        expect(parsed_body[:data]).to include(comment_parsed(comment))
      end
    end
  end

  describe 'POST /api/v1/comments' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment) }
    let(:postx) { create(:post) }
    let(:valid_attributes) do
      {
        name: 'The comment',
        comment: 'The super comment',
        user_id: user.id,
        post_id: postx.id
      }
    end

    context 'when user is logged in' do
      context 'with valid params' do
        it 'creates a new comment' do
          expect {
            post api_v1_comments_path, params: valid_attributes, headers: authenticated_header
          }.to change(Comment, :count).by(1)

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

  describe 'PUT /api/v1/comments/:id' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment, comment: 'The old comment') }
    let(:new_attributes) { { comment: 'A new comment text' } }

    context 'when user is logged in' do
      context 'with valid params' do
        it 'updates the requested post' do
          put api_v1_comment_path(comment), params: new_attributes, headers: authenticated_header

          expect(response).to have_http_status(:ok)
          expect(parsed_body[:successful]).to be true  
          expect(comment.reload.comment).to eq('A new comment text')
        end
      end

      context 'with invalid params' do
        it 'returns unprocessable_entity status' do
          put api_v1_comment_path(comment), params: { comment: '' }, headers: authenticated_header

          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_body[:successful]).to be false
          expect(comment.reload.comment).to eq("The old comment")
          expect(parsed_body[:errors]).to include("Comment can't be blank")
        end
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        put api_v1_comment_path(comment), params: new_attributes

        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include(
          'You are not authenticated. Please login to access this feature'
        )
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment) }

    context 'when user is logged in' do
      it 'destroys the requested comment' do
        delete api_v1_comment_path(comment), headers: authenticated_header

        expect(response).to have_http_status(:no_content)
        expect(Comment.exists?(comment.id)).to be_falsey
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        delete api_v1_comment_path(comment)

        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body[:successful]).to be false
        expect(parsed_body[:errors]).to include(
          'You are not authenticated. Please login to access this feature'
        )
      end
    end
  end
end
