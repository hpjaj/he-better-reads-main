require 'rails_helper'

RSpec.describe 'API::ApplicationController', type: :request do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }

  describe '#authenticate' do
    let(:user) { create :user }

    context 'when passing a valid token' do
      it 'returns a 200 OK' do
        get api_users_path, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
      end

      it 'sets #current_user' do
        get api_users_path, headers: auth_headers(user)

        expect(assigns(:current_user)).to eq user
      end
    end

    context 'when not providing any token' do
      it 'returns a 401 unauthorized' do
        get api_users_path

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a relevant error message' do
        get api_users_path

        expect(response_hash.dig(:error)).to include 'token'
      end

      it 'does not set #current_user' do
        get api_users_path

        expect(assigns(:current_user)).to be_nil
      end
    end

    context 'when providing an invalid token' do
      let(:headers) { { "Authorization" => "Bearer some_token" } }

      it 'returns a 401 unauthorized' do
        get api_users_path, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a relevant error message' do
        get api_users_path, headers: headers

        expect(response_hash.dig(:error)).to include 'does not match decoding'
      end

      it 'does not set #current_user' do
        get api_users_path, headers: headers

        expect(assigns(:current_user)).to be_nil
      end
    end

    context 'when providing an expired token' do
      let(:token) { JWTAuth.encode(user_id: user.id, expiration: Time.now.to_i - 1000) }
      let(:headers) { { "Authorization" => "Bearer #{token}" } }

      it 'returns a 401 unauthorized' do
        get api_users_path, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a relevant error message' do
        get api_users_path, headers: headers

        expect(response_hash.dig(:error)).to include 'expired'
      end

      it 'does not set #current_user' do
        get api_users_path, headers: headers

        expect(assigns(:current_user)).to be_nil
      end
    end

    context 'when providing a #user_id that does not exist in the database' do
      let(:token) { JWTAuth.encode(user_id: 99999) }
      let(:headers) { { "Authorization" => "Bearer #{token}" } }

      it 'returns a 404 not found' do
        get api_users_path, headers: headers

        expect(response).to have_http_status(:not_found)
      end

      it 'does not set #current_user' do
        get api_users_path, headers: headers

        expect(assigns(:current_user)).to be_nil
      end
    end
  end
end
