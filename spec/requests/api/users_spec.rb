RSpec.describe '/api/users' do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }

  describe 'GET to /' do
    it 'returns all users' do
      user = create(:user)

      get api_users_path, headers: auth_headers(user)

      expect(response_hash).to eq(
        [
          {
            first_name: user.first_name,
            last_name: user.last_name,
            id: user.id,
            email: user.email,
            token: nil
          }
        ]
      )
    end
  end

  describe 'GET to /:id' do
    context 'when found' do
      it 'returns an user' do
        user = create(:user)

        get api_user_path(user), headers: auth_headers(user)

        expect(response_hash).to eq(
          {
            first_name: user.first_name,
            last_name: user.last_name,
            id: user.id,
            email: user.email,
            token: nil
          }
        )
      end
    end

    context 'when not found' do
      let(:user) { create :user }

      it 'returns not_found' do
        get api_user_path(-1), headers: auth_headers(user)

        expect(response).to be_not_found
      end
    end
  end

  describe 'POST to /' do
    context 'when successful' do
      let(:params) do
        {
          first_name: 'Harry',
          last_name: 'Potter',
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it 'creates an user' do
        expect { post api_users_path, params: params }.to change { User.count }
      end

      it 'returns the created user', :aggregate_failures do
        post api_users_path, params: params

        expect(response_hash.dig(:first_name)).to eq params[:first_name]
        expect(response_hash.dig(:last_name)).to eq params[:last_name]
        expect(response_hash.dig(:email)).to eq params[:email]
      end

      it 'returns a JWT token' do
        post api_users_path, params: params

        expect(response_hash.dig(:token)).to be_present
      end
    end

    context 'when unsuccessful' do
      let(:params) {}

      it 'returns an error' do
        post api_users_path, params: params

        expect(response_hash.dig(:errors)).to contain_exactly(
          'First name can\'t be blank',
          'Last name can\'t be blank',
          'Email can\'t be blank',
          'Password can\'t be blank'
        )
      end
    end
  end

  describe 'PUT to /:id' do
    let(:user) { create(:user) }

    context 'when successful' do
      let(:params) do
        {
          first_name: 'James'
        }
      end

      it 'updates an existing user' do
        put api_user_path(user), params: params, headers: auth_headers(user)

        expect(user.reload.first_name).to eq(params[:first_name])
      end

      it 'returns the updated user' do
        put api_user_path(user), params: params, headers: auth_headers(user)

        expect(response_hash).to include(params)
      end
    end

    context 'when unsuccessful' do
      let(:params) do
        {
          first_name: ''
        }
      end

      it 'returns an error' do
        put api_user_path(user), params: params, headers: auth_headers(user)

        expect(response_hash).to eq(
          {
            errors: [
              'First name can\'t be blank'
            ]
          }
        )
      end
    end
  end
end
