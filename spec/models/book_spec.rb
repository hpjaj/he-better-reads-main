require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      book = build :book

      expect(book).to be_valid
    end
  end
end
