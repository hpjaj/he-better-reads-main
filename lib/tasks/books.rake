namespace :books do
  desc "Backfill :average_rating column on the Books table"
  task add_average_rating: :environment do
    reporting = { success: 0, failures: 0 }
    books     = Book.where(average_rating: nil)

    books.find_each do |book|
      begin
        average = Review.where(reviewable: book).average(:rating)

        book.update!(average_rating: average)

        reporting[:success] += 1
      rescue StandardError => e
        p "Error for book #{book.id}: #{e.message}"

        reporting[:failures] += 1
      end
    end

    p "Results: #{reporting}"
  end
end
