module API
  class ReviewsController < ApplicationController
    before_action :set_reviewable!

    def index
      reviews = Review
        .includes(:user)
        .where(reviewable: @reviewable)
        .order(created_at: :desc)

      render json: reviews, each_serializer: ReviewSerializer
    end

    def create
      review = Review.new(review_attrs)

      if review.save
        render json: review, serializer: ReviewSerializer
      else
        render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
      end
    end

  private

    def set_reviewable!
      if reviewable_type == 'Book'
        @reviewable = Book.find_by!(uuid: reviewable_id)
      end
    end

    def reviewable_type
      params[:reviewable_type].capitalize
    end

    def reviewable_id
      params[:reviewable_id]
    end

    def review_params
      params.require(:review).permit(:rating, :description, :reviewable_id, :reviewable_type)
    end

    def review_attrs
      review_params.merge(user: @current_user, reviewable: @reviewable)
    end
  end
end
