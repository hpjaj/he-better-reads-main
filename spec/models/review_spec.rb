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
end
