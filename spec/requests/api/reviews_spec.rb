require 'rails_helper'

RSpec.describe '/api/reviews', type: :request do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }

  describe 'GET to /:reviewable_type/:reviewable_id' do
    let(:user) { create :user }
    let(:book) { create :book }
    let!(:review) { create :review, user: user, reviewable: book }

    context 'when found' do
      it 'returns all reviews for the passed book' do
        get api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), headers: auth_headers(user)

        expect(response_hash).to eq(
          [
            {
              id:              review.id,
              reviewable_type: review.reviewable_type,
              reviewable_id:   review.reviewable_id,
              description:     review.description,
              rating:          review.rating,
              created_at:      review.created_at.iso8601(3),
              user: {
                id:         user.id,
                first_name: user.first_name,
                last_name:  user.last_name,
                email:      user.email,
                token:      nil
              }
            }
          ]
        )
      end

      it 'returns a 200 OK' do
        get api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not found' do
      it 'returns a 404 not_found' do
        get api_reviews_path(reviewable_type: 'book', reviewable_id: -1), headers: auth_headers(user)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST to /:reviewable_type/:reviewable_id' do
    let(:user) { create :user }
    let(:book) { create :book }

    context 'when successful' do
      let(:params) do
        {
          review: {
            rating: '2',
            description: 'some description',
            reviewable_type: 'book',
            reviewable_id: book.uuid
          }
        }
      end

      it 'creates a review' do
        expect {
          post api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), params: params, headers: auth_headers(user)
        }.to change { Review.count }
      end

      it 'returns the created review', :aggregate_failures do
        post api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), params: params, headers: auth_headers(user)

        expect(response_hash.dig(:id)).to be_present
        expect(response_hash.dig(:created_at)).to be_present
        expect(response_hash.except(:id, :created_at)).to eq(
          {
            reviewable_type: book.class.to_s,
            reviewable_id:   book.id,
            description:     params.dig(:review, :description),
            rating:          params.dig(:review, :rating).to_i,
            user: {
              id:         user.id,
              first_name: user.first_name,
              last_name:  user.last_name,
              email:      user.email,
              token:      nil
            }
          }
        )
      end

      it 'returns a 200 OK' do
        post api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), params: params, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unsuccessful' do
      let(:params) do
        {
          review: {
            rating: '',
            description: 'some description',
            reviewable_type: 'book',
            reviewable_id: book.uuid
          }
        }
      end

      it 'returns a 420 unprocessable_entity' do
        post api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), params: params, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an array of descriptive errors' do
        post api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), params: params, headers: auth_headers(user)

        expect(response_hash.dig(:errors)).to be_present
      end

      it 'does not create a review' do
        expect {
          post api_reviews_path(reviewable_type: 'book', reviewable_id: book.uuid), params: params, headers: auth_headers(user)
        }.to_not change { Review.count }
      end
    end
  end
end
