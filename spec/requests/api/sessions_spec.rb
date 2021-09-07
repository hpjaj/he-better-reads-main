require 'rails_helper'

RSpec.describe '/api/sessions', type: :request do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }
  let(:email) { 'user@example.com' }
  let(:password) { 'password' }
  let!(:user) { create :user, email: email, password: password }

  describe 'POST to /' do
    context 'when successful' do
      let(:params) do
        {
          email: email,
          password: password
        }
      end

      it 'returns a 200 OK' do
        post api_sessions_path, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'returns the logged in user and token', :aggregate_failures do
        post api_sessions_path, params: params

        expect(response_hash.dig(:token)).to be_present
        expect(response_hash.except(:token)).to eq(
          {
            id:         user.id,
            first_name: user.first_name,
            last_name:  user.last_name,
            email:      user.email
          }
        )
      end

      it 'does not require Authorization headers to be present' do
        post api_sessions_path, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unsuccessful' do
      context 'with an incorrect password' do
        let(:params) do
          {
            email: email,
            password: 'wrong_password'
          }
        end

        it 'returns a 420 unprocessable_entity' do
          post api_sessions_path, params: params

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          post api_sessions_path, params: params

          expect(response_hash.dig(:error)).to be_present
        end
      end

      context 'with an email address that is not present in the db' do
        let(:params) do
          {
            email: 'bad_email@example.com',
            password: password
          }
        end

        it 'returns a 404 not_found' do
          post api_sessions_path, params: params

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'GET to /' do
    it 'requires valid Authorization headers to be passed' do
      get api_sessions_path

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a 200 OK' do
      get api_sessions_path, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
    end

    it 'returns the logged in user', :aggregate_failures do
      get api_sessions_path, headers: auth_headers(user)

      expect(response_hash).to eq(
        {
          id:         user.id,
          first_name: user.first_name,
          last_name:  user.last_name,
          email:      user.email,
          token:      nil
        }
      )
    end
  end

  describe 'DELETE to /' do
    it 'sets #current_user to nil' do
      delete api_sessions_path, headers: auth_headers(user)

      expect(assigns(:current_user)).to be_nil
    end
  end
end
