module API
  class BooksController < ApplicationController
    def create
      book = Book.new(allowed_params)

      if book.save
        render json: book, serializer: BookSerializer
      else
        render json: { errors: book.errors.full_messages }
      end
    end

    def index
      render json: Book.includes(:author).all, each_serializer: BookSerializer
    end

    def show
      render json: Book.find_by!(uuid: params[:uuid]), serializer: BookSerializer
    end

    def update
      book = Book.find_by!(uuid: params[:uuid])

      if book.update(allowed_params)
        render json: book, serializer: BookSerializer
      else
        render json: { errors: book.errors.full_messages }
      end
    end

    private

    def allowed_params
      params.permit(
        :author_id,
        :description,
        :publish_date,
        :rating,
        :title
      )
    end
  end
end
