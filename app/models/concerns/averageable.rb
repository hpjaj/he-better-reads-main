module Averageable
  extend ActiveSupport::Concern

  # Rounds the :average_rating value to the nearest passed place (i.e to the nearest 0.5).
  # Included class must have an existing or aliased method called :average_rating
  #
  # @param place [Float] i.e. 0.5
  # @return [Float]
  #
  def rating_to_the_nearest(place)
    average_rating_defined!

    adjuster = (1 / place)
    adjusted_rating = average_rating * adjuster

    adjusted_rating.round / adjuster
  end

private

  def average_rating_defined!
    return if respond_to?(:average_rating)

    raise NoMethodError, "Required instance method :average_rating is not defined on #{self.class}"
  end
end
