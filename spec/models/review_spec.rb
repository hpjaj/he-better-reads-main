require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      review = create :review

      expect(review).to be_valid
    end

    describe '#one_per_user' do
      let(:user) { create :user }
      let(:book) { create :book }
      let!(:review) { create :review, user: user, reviewable: book }

      it 'is invalid if a user tries to create more than one review for a given :reviewable item' do
        duplicate_review = build :review, user: user, reviewable: book
        duplicate_review.save

        expect(duplicate_review).to_not be_valid
      end

      it 'is valid for a user to review a different :reviewable item' do
        book   = create :book
        review = create :review, user: user, reviewable: book

        expect(review).to be_valid
      end

      it 'is valid to update an existing review' do
        review.update(rating: 1)

        expect(review.reload).to be_valid
      end
    end
  end

  describe 'callbacks' do
    describe '#update_book_rating' do
      let(:book) { create :book }

      context '#after_commit' do
        before do
          create :review, reviewable: book, rating: 2
        end

        it 'updates the reviewable#average_rating', :aggregate_failures do
          expect(book.reload.average_rating).to eq 2.0

          create :review, reviewable: book, rating: 4

          expect(book.reload.average_rating).to eq 3.0
        end
      end

      context '#after_destroy' do
        before do
          create :review, reviewable: book, rating: 2
          create :review, reviewable: book, rating: 4
        end

        it 'updates the reviewable#average_rating', :aggregate_failures do
          expect(book.reload.average_rating).to eq 3.0

          book.reviews.last.destroy!

          expect(book.reload.average_rating).to eq 2.0
        end
      end
    end
  end
end
