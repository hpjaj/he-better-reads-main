module API
  class SessionsController < ApplicationController
    skip_before_action :authenticate, only: :create

    def create
      user = User.find_by!(email: email)

      if user.authenticate(password)
        token = JWTAuth.encode(user_id: user.id)

        render json: user, serializer: UserSerializer, token: token
      else
        render json: { error: "Incorrect password" }, status: :unprocessable_entity
      end
    end

    def show
      render json: @current_user, serializer: UserSerializer
    end

    def destroy
      sign_out_current_user

      head :ok
    end

  private

    def sessions_params
      params.permit(:email, :password)
    end

    def email
      sessions_params[:email].downcase.strip
    end

    def password
      sessions_params[:password].strip
    end
  end
end
