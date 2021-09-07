require 'rails_helper'

RSpec.describe Averageable do
  describe '#rating_to_the_nearest' do
    let(:adjuster) { 0.5 }

    context 'when average_rating should round down' do
      it 'returns the expected rounded rating', :aggregate_failures do
        sample_model = SampleModel.new(average_rating: 3.126666)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.0

        sample_model = SampleModel.new(average_rating: 3.231)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.0

        sample_model = SampleModel.new(average_rating: 3.01)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.0
      end
    end

    context 'when average_rating should round up' do
      it 'returns the expected rounded rating', :aggregate_failures do
        sample_model = SampleModel.new(average_rating: 3.49)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.5

        sample_model = SampleModel.new(average_rating: 3.331)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.5

        sample_model = SampleModel.new(average_rating: 3.26)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.5
      end
    end

    context 'when average_rating should not round' do
      it 'returns the expected rounded rating', :aggregate_failures do
        sample_model = SampleModel.new(average_rating: 3.5)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.5

        sample_model = SampleModel.new(average_rating: 3.0)
        expect(sample_model.rating_to_the_nearest(adjuster)).to eq 3.0
      end
    end

    context 'when the included class does not have an #average_rating instance method' do
      it 'raise a NoMethodError' do
        expect {
          BadSampleModel.new.rating_to_the_nearest(adjuster)
        }.to raise_error(NoMethodError)
      end
    end
  end
end

class SampleModel < ApplicationRecord
  self.table_name = 'books'

  include Averageable

  attr_accessor :average_rating
end

class BadSampleModel < ApplicationRecord
  self.table_name = 'books'

  include Averageable
end
