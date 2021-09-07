require 'rails_helper'

RSpec.describe JWTAuth do
  let(:user_id) { 1 }

  describe '.encode' do
    it 'returns an encrypted JWT', :aggregate_failures do
      token = JWTAuth.encode(user_id: user_id)

      expect(token).to be_present
      expect(token.class).to eq String
    end

    it 'sets an expiration, by default' do
      token   = JWTAuth.encode(user_id: user_id)
      payload = JWTAuth.decode!(token)

      expect(payload.dig('exp')).to be_present
    end
  end

  describe '.decode!' do
    let(:token) { JWTAuth.encode(user_id: user_id) }
    let(:payload) { JWTAuth.decode!(token) }

    it 'returns a hash of the encrypted payload', :aggregate_failures do
      expect(payload.dig('user_id')).to eq user_id
      expect(payload.dig('exp')).to be_present
    end

    context 'with an expired JWT' do
      let(:token) { JWTAuth.encode(user_id: user_id, expiration: 1.day.ago.to_i) }

      it 'raises an ArgumentError' do
        expect { JWTAuth.decode!(token) }.to raise_error(ArgumentError)
      end
    end

    context 'with an invalid token' do
      let(:token) { 'some_invalid_token' }

      it 'raises an ArgumentError' do
        expect { JWTAuth.decode!(token) }.to raise_error(ArgumentError)
      end
    end
  end
end
