require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      author = build :author

      expect(author).to be_valid
    end
  end
end
