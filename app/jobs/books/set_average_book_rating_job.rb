class Books::SetAverageBookRatingJob < ApplicationJob
  queue_as :default

  def perform(book_id:)
    book    = Book.find_by!(id: book_id)
    average = Review.where(reviewable: book).average(:rating)

    book.update!(average_rating: average)
  end
end
