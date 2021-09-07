module API
  class UsersController < ApplicationController
    skip_before_action :authenticate, only: :create

    def create
      user = User.new(allowed_params)

      if user.save
        token = JWTAuth.encode(user_id: user.id)

        render json: user, serializer: UserSerializer, token: token
      else
        render json: { errors: user.errors.full_messages }
      end
    end

    def index
      render json: User.all
    end

    def show
      render json: User.find(params[:id])
    end

    def update
      user = User.find(params[:id])

      if user.update(allowed_params)
        render json: user
      else
        render json: { errors: user.errors.full_messages }
      end
    end

    private

    def allowed_params
      params.permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation
      )
    end
  end
end
