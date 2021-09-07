module API
  class AuthorsController < ApplicationController
    def create
      author = Author.new(allowed_params)

      if author.save
        render json: author, serializer: AuthorSerializer
      else
        render json: { errors: author.errors.full_messages }
      end
    end

    def index
      render json: Author.all, each_serializer: AuthorSerializer
    end

    def show
      render json: Author.find(params[:id]), serializer: AuthorSerializer
    end

    def update
      author = Author.find(params[:id])

      if author.update(allowed_params)
        render json: author, serializer: AuthorSerializer
      else
        render json: { errors: author.errors.full_messages }
      end
    end

    private

    def allowed_params
      params.permit(
        :description,
        :first_name,
        :last_name,
        :website,
        genres: []
      )
    end
  end
end
