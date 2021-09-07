class Review < ApplicationRecord
  belongs_to :user
  belongs_to :reviewable, polymorphic: true, counter_cache: true

  validates :rating, :reviewable, :user_id, presence: true
  validates(
    :rating,
    numericality: {
      only_integer: true,
      greater_than: 0,
      less_than_or_equal_to: 5,
      message: 'must be a whole number from 1 - 5 (no decimals)'
    }
  )
  validate :one_per_user, on: :create

private

  # Favor custom validation over uniqueness/scope to ensure custom error message does not contain `User`.
  # Also more flexible with other polymorphic relationships.
  #
  def one_per_user
    review = Review.exists?(user_id: user_id, reviewable_type: reviewable_type, reviewable_id: reviewable_id)

    if review
      errors.add(:base, "You can only submit one review for this #{reviewable_type.downcase}")
    end
  end
end
